//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import DiscordCore
import DiscordREST
import WebSocketClient

public final class GatewaySession: Sendable {
    public let apiVersion: DiscordAPIVersion?
    public let encoding: Encoding
    public let restSession: RESTSession

    let actor = Actor()

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
        await self.actor.run {
            $0.webSocketSession = webSocketSession
        }
        try await webSocketSession.connect()
    }

    public func connect() async throws {
        let gateway = try await Gateway(session: self.restSession)
        try await self.connect(url: gateway.url)
    }

    public func disconnect() throws {
        // TODO: Implement
    }

    public func send<D>(payload: GatewayPayload<D>) async throws where D: Encodable {
        guard let webSocketSession = await actor.webSocketSession else {
            return
        }

        let encoder: any TopLevelEncoder<Foundation.Data> = {
            switch configuration.encoding {
            case .json:
                JSONEncoder.discord
            }
        }()

        let data = try encoder.encode(payload)

        try await webSocketSession.send(.string(String(decoding: data, as: UTF8.self)))
    }
}

extension GatewaySession {
    public enum Encoding: String, Sendable {
        case json
    }
}
