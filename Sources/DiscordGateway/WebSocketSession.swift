//
//  WebSocketSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation
import NIOCore
import NIOPosix
import NIOHTTP1
import NIOWebSocket
#if canImport(NIOTransportServices)
import NIOTransportServices
import Network
#else
import NIOFoundationCompat
#endif

class WebSocketSession {
    unowned let gatewaySession: GatewaySession
    let gatewayURL: URL

    private var channel: Channel?
    private weak var context: ChannelHandlerContext?

    init(gatewaySession: GatewaySession, gatewayURL: URL) {
        self.gatewaySession = gatewaySession
        self.gatewayURL = gatewayURL
    }

    deinit {
        context?.close(mode: .all, promise: nil)
    }
}

extension WebSocketSession {
    func connect() async throws {
        #if canImport(NIOTransportServices)
        let bootstrap = NIOTSConnectionBootstrap(group: gatewaySession.eventLoopGroup)
            .tlsOptions(NWProtocolTLS.Options())
        #else
        let bootstrap = ClientBootstrap(group: gatewaySession.eventLoopGroup)
        #endif

        self.channel = try await bootstrap
            // Enable SO_REUSEADDR.
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in

                let httpHandler = HTTPInitialRequestHandler(url: self.gatewayURL)

                let websocketUpgrader = NIOWebSocketClientUpgrader(requestKey: "OfS0wDaT5NoxF2gqm7Zj2YtetzM=",
                                                                   upgradePipelineHandler: { (channel: NIOCore.Channel, _: HTTPResponseHead) in
                    channel.pipeline.addHandler(self)
                })

                let config: NIOHTTPClientUpgradeConfiguration = (
                    upgraders: [ websocketUpgrader ],
                    completionHandler: { _ in
                        channel.pipeline.removeHandler(httpHandler, promise: nil)
                })

                return channel.pipeline.addHTTPClientHandlers(leftOverBytesStrategy: .forwardBytes, withClientUpgrade: config).flatMap {
                    channel.pipeline.addHandler(httpHandler)
                }
            }
            .connect(host: self.gatewayURL.host!, port: self.gatewayURL.port ?? 443)
            .get()
    }

    func send<S>(opcode: WebSocketOpcode, bytes: S) async throws where S: Sequence, S.Element == UInt8 {
        guard let context = context else {
            return
        }

        try await context.eventLoop
            .submit {
                let buffer = context.channel.allocator.buffer(bytes: bytes)
                let frame = WebSocketFrame(
                    fin: true,
                    opcode: opcode,
                    maskKey: .random(),
                    data: buffer
                )

                return context.writeAndFlush(self.wrapOutboundOut(frame))
            }
            .get()
            .get()
    }
}

extension WebSocketSession {
    private func receivedClose(context: ChannelHandlerContext, frame: WebSocketFrame) {
        // Handle a received close frame. We're just going to close.
        print("Received Close instruction from server")
        context.close(promise: nil)
    }

    private func closeOnError(context: ChannelHandlerContext) {
        // We have hit an error, we want to close. We do that by sending a close frame and then
        // shutting down the write side of the connection. The server will respond with a close of its own.
        var data = context.channel.allocator.buffer(capacity: 2)
        data.write(webSocketErrorCode: .protocolError)
        let frame = WebSocketFrame(fin: true, opcode: .connectionClose, data: data)
        context.write(self.wrapOutboundOut(frame)).whenComplete { (_: Result<Void, Error>) in
            context.close(mode: .output, promise: nil)
        }
    }
}

extension WebSocketSession: ChannelInboundHandler {
    public typealias InboundIn = WebSocketFrame
    public typealias OutboundOut = WebSocketFrame

    // This is being hit, channel active won't be called as it is already added.
    func handlerAdded(context: ChannelHandlerContext) {
        self.context = context
        print("WebSocket handler added.")
    }

    func handlerRemoved(context: ChannelHandlerContext) {
        self.context = nil
        print("WebSocket handler removed.")
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let frame = self.unwrapInboundIn(data)

        switch frame.opcode {
        case .text:
            Task {
                await gatewaySession.didReceiveMessage(frame: frame, context: context)
            }
        case .connectionClose:
            self.receivedClose(context: context, frame: frame)
        default:
            break
        }
    }

    func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        debugPrint(error)
    }
}
