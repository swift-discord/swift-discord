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
}

extension GatewaySession {
    private static var gatewayURL: URL {
        URL(string: "wss://gateway.discord.gg/?v=10&encoding=json")!
    }

    public func connect() async throws {
        let webSocketSession = WebSocketSession(gatewayURL: Self.gatewayURL, configuration: .init(), delegate: self)
        self.webSocketSession = webSocketSession
        try await webSocketSession.connect()
    }

    public func disconnect() throws {
        // TODO: Implement
    }
}
