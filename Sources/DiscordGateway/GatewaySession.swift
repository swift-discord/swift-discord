//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import DiscordCore
import Foundation
import WebSocket

public actor GatewaySession {

    public let apiVersion: DiscordAPIVersion
    public let encoding: Encoding
    public let authenticationToken: String?

    var webSocketSession: WebSocketSession?

    var lastHeartbeatACKDate: Date = .distantFuture
    var heartbeatInterval: TimeInterval = .leastNormalMagnitude

    var sequence: Int?

    public init(
        apiVersion: DiscordAPIVersion = .latest,
        encoding: Encoding = .json,
        authenticationToken: String)
    {
        self.apiVersion = apiVersion
        self.encoding = encoding
        self.authenticationToken = authenticationToken
    }
}

extension GatewaySession {

    public func connect(url: URL) async throws {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if urlComponents.path.isEmpty {
            urlComponents.path = "/"
        }
        urlComponents.queryItems = [
            .init(name: "v", value: apiVersion.versionString),
            .init(name: "encoding", value: encoding.rawValue),
        ]
        let webSocketSession = WebSocketSession(url: urlComponents.url!, configuration: .init(), delegate: self)
        self.webSocketSession = webSocketSession
        try await webSocketSession.connect()
    }

    public func disconnect() throws {
        // TODO: Implement
    }
}

extension GatewaySession {

    public enum Encoding: String {

        case json
    }
}
