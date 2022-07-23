//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import WebSocket

public actor GatewaySession {
    public let authenticationToken: String?

    var webSocketSession: WebSocketSession?

    var lastHeartbeatACKDate: Date = .distantFuture
    var heartbeatInterval: TimeInterval = .leastNormalMagnitude

    var sequence: Int?

    public init(authenticationToken: String) {
        self.authenticationToken = authenticationToken
    }

//    deinit {
//        eventLoopGroup.shutdownGracefully { _ in }
//    }
}

extension GatewaySession {
    private static var gatewayURL: URL {
        URL(string: "wss://gateway.discord.gg/?v=10&encoding=json")!
    }

    public func connect() async throws {
        self.webSocketSession = WebSocketSession(gatewayURL: Self.gatewayURL, configuration: .init(), delegate: self)
        try await self.webSocketSession!.connect()
    }

    public func disconnect() throws {
        // TODO: Implement
    }
}
