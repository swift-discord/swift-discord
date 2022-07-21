//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord
import NIOCore
import NIOPosix
import NIOHTTP1
import NIOWebSocket
#if canImport(NIOTransportServices)
import NIOTransportServices
import Network
#endif

public actor GatewaySession {
    public let session: Session

    let eventLoopGroup: EventLoopGroup
    weak var channel: Channel?

    var lastHeartbeatACKDate: Date = .distantFuture
    var heartbeatInterval: TimeInterval = .leastNormalMagnitude

    var sequence: Int?

    public init(session: Session) {
        self.session = session

        #if canImport(NIOTransportServices)
        self.eventLoopGroup = NIOTSEventLoopGroup(loopCount: 1, defaultQoS: .default)
        #else
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        #endif
    }

    deinit {
        channel?.close(mode: .all, promise: nil)
        eventLoopGroup.shutdownGracefully { _ in }
    }
}

extension GatewaySession {
    private static var gatewayURL: URL {
        URL(string: "wss://gateway.discord.gg/?v=10&encoding=json")!
    }

    public func connect() throws {
        #if canImport(NIOTransportServices)
        let bootstrap = NIOTSConnectionBootstrap(group: eventLoopGroup)
            .tlsOptions(NWProtocolTLS.Options())
        #else
        let bootstrap = ClientBootstrap(group: eventLoopGroup)
        #endif

        self.channel = try bootstrap
            // Enable SO_REUSEADDR.
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in

                let httpHandler = HTTPInitialRequestHandler(url: Self.gatewayURL)

                let websocketUpgrader = NIOWebSocketClientUpgrader(requestKey: "OfS0wDaT5NoxF2gqm7Zj2YtetzM=",
                                                                   upgradePipelineHandler: { (channel: Channel, _: HTTPResponseHead) in
                    channel.pipeline.addHandler(self)
                })

                let config: NIOHTTPClientUpgradeConfiguration = (
                    upgraders: [ websocketUpgrader ],
                    completionHandler: { _ in
                        channel.pipeline.removeHandler(httpHandler, promise: nil)
                })

                return channel.pipeline.addHTTPClientHandlers(withClientUpgrade: config).flatMap {
                    channel.pipeline.addHandler(httpHandler)
                }
            }
            .connect(host: Self.gatewayURL.host!, port: Self.gatewayURL.port ?? 443).wait()
    }
}

extension GatewaySession: ChannelInboundHandler {
    public typealias InboundIn = WebSocketFrame
    public typealias OutboundOut = WebSocketFrame

    // This is being hit, channel active won't be called as it is already added.
    public nonisolated func handlerAdded(context: ChannelHandlerContext) {
        print("WebSocket handler added.")
    }

    public nonisolated func handlerRemoved(context: ChannelHandlerContext) {
        print("WebSocket handler removed.")
    }

    public nonisolated func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let frame = self.unwrapInboundIn(data)

        Task {
            await didReceiveMessage(frame: frame, context: context)
        }
    }

    public nonisolated func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }
}

extension GatewaySession {
    private func didReceiveMessage(frame: InboundIn, context: ChannelHandlerContext) {
        do {
            let jsonDecoder = JSONDecoder()
            let payload = try jsonDecoder.decode(GatewayPayload.self, from: frame.data)

            switch frame.opcode {
            case .discordHello:
                let heartbeatInterval = payload.data?.dictionaryValue?["heartbeat_interval"]?.intValue.flatMap {
                    TimeInterval($0)
                }

                self.heartbeatInterval = heartbeatInterval ?? self.heartbeatInterval
                self.lastHeartbeatACKDate = Date()
            case .discordHeartbeatACK:
                self.lastHeartbeatACKDate = Date()
            case .text:
                var data = frame.unmaskedData
                let text = data.readString(length: data.readableBytes) ?? ""
                print("Websocket: Received \(text)")
            case .connectionClose:
                self.receivedClose(context: context, frame: frame)
            case .binary, .continuation, .ping:
                // We ignore these frames.
                break
            default:
                // Unknown frames are errors.
                self.closeOnError(context: context)
            }

            sequence = payload.sequence ?? sequence

            if Date() < lastHeartbeatACKDate.addingTimeInterval(heartbeatInterval) {
                try heartbeat(context: context)
            }
        } catch {

        }
    }

    private func heartbeat(context: ChannelHandlerContext) throws {
        let payload = GatewayPayload(
            opcode: 1,
            data: sequence.flatMap { .int($0) },
            sequence: nil,
            type: nil
        )

        let jsonEncoder = JSONEncoder.discord

        let buffer = context.channel.allocator.buffer(data: try jsonEncoder.encode(payload))
        let frame = WebSocketFrame(fin: false, opcode: .discordHeartbeat, data: buffer)
        context.write(self.wrapOutboundOut(frame), promise: nil)
    }

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
