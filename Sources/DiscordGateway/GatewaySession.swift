//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
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

public actor GatewaySession {
    public let authenticationToken: String?

    let eventLoopGroup: EventLoopGroup
    var webSocketSession: WebSocketSession?

    var lastHeartbeatACKDate: Date = .distantFuture
    var heartbeatInterval: TimeInterval = .leastNormalMagnitude

    var sequence: Int?

    public init(authenticationToken: String) {
        self.authenticationToken = authenticationToken

        #if canImport(NIOTransportServices)
        self.eventLoopGroup = NIOTSEventLoopGroup(loopCount: 1, defaultQoS: .default)
        #else
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        #endif
    }

    deinit {
        eventLoopGroup.shutdownGracefully { _ in }
    }
}

extension GatewaySession {
    private static var gatewayURL: URL {
        URL(string: "wss://gateway.discord.gg/?v=10&encoding=json")!
    }

    public func connect() async throws {
        self.webSocketSession = WebSocketSession(gatewaySession: self, gatewayURL: Self.gatewayURL)
        try await self.webSocketSession!.connect()
    }

    public func disconnect() throws {
        // TODO: Implement
    }
}
