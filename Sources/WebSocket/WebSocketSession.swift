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

public class WebSocketSession {
    public typealias Delegate = WebSocketSessionDelegate

    public let gatewayURL: URL
    public let configuration: Configuration
    public private(set) weak var delegate: Delegate?

    private var channel: Channel?

    public init(gatewayURL: URL, configuration: Configuration, delegate: WebSocketSessionDelegate) {
        self.gatewayURL = gatewayURL
        self.configuration = configuration
        self.delegate = delegate
    }

    deinit {
        channel?.close(mode: .all, promise: nil)
    }
}

extension WebSocketSession {
    public func connect() async throws {
        #if canImport(NIOTransportServices)
        let bootstrap = NIOTSConnectionBootstrap(group: configuration.eventLoopGroup)
            .tlsOptions(NWProtocolTLS.Options())
        #else
        let bootstrap = ClientBootstrap(group: configuration.eventLoopGroup)
        #endif

        self.channel = try await bootstrap
            // Enable SO_REUSEADDR.
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer { channel in

                let httpHandler = HTTPInitialRequestHandler(url: self.gatewayURL)

                let websocketUpgrader = NIOWebSocketClientUpgrader(requestKey: "OfS0wDaT5NoxF2gqm7Zj2YtetzM=",
                                                                   upgradePipelineHandler: { (channel: NIOCore.Channel, _: HTTPResponseHead) in
                    channel.pipeline.addHandler(WebSocketHandler(webSocketSession: self))
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

    public func send(_ message: Message) async throws {
        guard let channel = channel else {
            return
        }

        let buffer = channel.allocator.buffer(webSocketSessionMessage: message)
        let frame = WebSocketFrame(
            fin: true,
            opcode: {
                switch message {
                case .string:
                    return .text
                case .data:
                    return .binary
                }
            }(),
            maskKey: .random(),
            data: buffer
        )

        return try await channel.writeAndFlush(frame)
    }
}

extension WebSocketSession {
    func send<S>(opcode: WebSocketOpcode, bytes: S) async throws where S: Sequence, S.Element == UInt8 {
        guard let channel = channel else {
            return
        }

        let buffer = channel.allocator.buffer(bytes: bytes)
        let frame = WebSocketFrame(
            fin: true,
            opcode: opcode,
            maskKey: .random(),
            data: buffer
        )

        return try await channel.writeAndFlush(frame)
    }

    func close(context: ChannelHandlerContext? = nil, errorCode: WebSocketErrorCode? = nil) async throws {
        guard let channel = context?.channel ?? self.channel else {
            return
        }

        if let errorCode = errorCode {
            // We have hit an error, we want to close. We do that by sending a close frame and then
            // shutting down the write side of the connection. The server will respond with a close of its own.
            var data = channel.allocator.buffer(capacity: 2)
            data.write(webSocketErrorCode: errorCode)
            let frame = WebSocketFrame(fin: true, opcode: .connectionClose, data: data)
            try await channel.write(frame).get()
            try await channel.close(mode: .output)
        } else {
            try await channel.close()
        }
    }
}

extension WebSocketSession {
    func receivedFrame(_ frame: WebSocketFrame, context: ChannelHandlerContext) {
        switch frame.opcode {
        case .text:
            var data = frame.unmaskedData
            guard let string = data.readString(length: data.readableBytes) else {
                delegate?.didReceiveMessage(
                    .data(Data(buffer: frame.unmaskedData)),
                    context: .init(session: self, channelHandlerContext: context, frame: frame)
                )
                break
            }

            delegate?.didReceiveMessage(
                .string(string),
                context: .init(session: self, channelHandlerContext: context, frame: frame)
            )
        case .binary:
            delegate?.didReceiveMessage(
                .data(Data(buffer: frame.unmaskedData)),
                context: .init(session: self, channelHandlerContext: context, frame: frame)
            )
        case .connectionClose:
            Task {
                try await self.close(context: context)
            }
        default:
            break
        }
    }
}
