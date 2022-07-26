//
//  WebSocketSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation
import NIOCore
import NIOHTTP1
import NIOWebSocket
@_implementationOnly import NIOPosix
#if canImport(NIOTransportServices)
@_implementationOnly import NIOTransportServices
@_implementationOnly import Network
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
        let bootstrap = NIOTSConnectionBootstrap(group: configuration.threadPool.eventLoopGroup)
            .tlsOptions(NWProtocolTLS.Options())
        #else
        let bootstrap = ClientBootstrap(group: configuration.threadPool.eventLoopGroup)
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

    public func disconnect() async throws {
        try await close()
    }
}

extension WebSocketSession {
    func close(frame: WebSocketFrame, context: ChannelHandlerContext) async throws {
        let data = Data(buffer: frame.unmaskedData)

        let closeCode: UInt16 = data.prefix(2)
            .withUnsafeBytes { (unsafeRawBufferPointer: UnsafeRawBufferPointer) in
                unsafeRawBufferPointer.load(as: UInt16.self)
            }

        let reason: Data = data.dropFirst(2)

        delegate?.didReceiveClose(
            code: .init(rawValue: closeCode),
            reason: reason,
            context: .init(session: self, channelHandlerContext: context, frame: frame)
        )

        try await close(code: nil)
    }

    func close(code: CloseCode? = .normalClosure, context: ChannelHandlerContext? = nil) async throws {
        guard let channel = context?.channel ?? channel else {
            return
        }

        if let closeCode = code {
            var data = channel.allocator.buffer(capacity: 2)
            data.write(webSocketErrorCode: closeCode.webSocketErrorCode)
            let frame = WebSocketFrame(fin: true, opcode: .connectionClose, data: data)
            try? await channel.writeAndFlush(frame).get()
        }

        try await channel.close()

        delegate?.didClose(context: .init(session: self, channelHandlerContext: nil, frame: nil))
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
                try await self.close(frame: frame, context: context)
            }
        default:
            break
        }
    }
}
