//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Dispatch
import DiscordCore
import DiscordREST
import WebSocketClient

public actor GatewaySession {
    public let apiVersion: DiscordAPIVersion?
    public let encoding: Encoding
    public let restSession: RESTSession

    var webSocketSession: WebSocketSession?

    var heartbeatInterval: TimeInterval = .leastNormalMagnitude

    var sequence: Int?

    internal var heartbeatTimer: DispatchSourceTimer? = nil

    public init(
        apiVersion: DiscordAPIVersion? = nil,
        encoding: Encoding = .json,
        restSession: RESTSession
    ) {
        self.apiVersion = apiVersion
        self.encoding = encoding
        self.restSession = restSession
    }
}

extension GatewaySession {
    public func connect(url: URL) async throws {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if urlComponents.path.isEmpty {
            urlComponents.path = "/"
        }

        var queryItems: [URLQueryItem] = [
            .init(name: "encoding", value: encoding.rawValue),
        ]
        if let apiVersion {
            queryItems.append(.init(name: "v", value: apiVersion.versionString))
        }
        urlComponents.queryItems = queryItems

        let webSocketSession = WebSocketSession(url: urlComponents.url!, configuration: .init(), delegate: self)
        self.webSocketSession = webSocketSession
        try await webSocketSession.connect()
    }

    public func connect() async throws {
        let gateway = try await Gateway(session: self.restSession)
        try await self.connect(url: gateway.url)
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
