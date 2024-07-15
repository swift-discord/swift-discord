//
//  GatewaySession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import DiscordCore
import DiscordREST
import WebSocketClientFoundationCompat

public final class GatewaySession: Sendable {
    public typealias EventHandler = @Sendable (any GatewayPayloadable) async -> Void

    public let configuration: Configuration
    public let restSession: RESTSession
    public let eventHandler: EventHandler

    let actor = Actor()

    public init(
        configuration: Configuration,
        restSession: RESTSession,
        eventHandler: @escaping EventHandler
    ) {
        self.configuration = configuration
        self.restSession = restSession
        self.eventHandler = eventHandler
    }
}

extension GatewaySession {
    public enum Encoding: String, Sendable {
        case json
    }
}

extension GatewaySession {
    public func connect() async throws {
        let gateway = try await Gateway(session: self.restSession)
        try await self.connect(to: gateway.url)
    }

    public func connect(to gatewayURL: URL) async throws {
        var urlComponents = URLComponents(url: gatewayURL, resolvingAgainstBaseURL: true)!
        if urlComponents.path.isEmpty {
            urlComponents.path = "/"
        }

        var queryItems: [URLQueryItem] = [
            .init(name: "encoding", value: configuration.encoding.rawValue),
        ]
        if let apiVersion = configuration.apiVersion {
            queryItems.append(.init(name: "v", value: apiVersion.versionString))
        }
        urlComponents.queryItems = queryItems

        let webSocketURL = urlComponents.url!
        guard let webSocket = WebSocketClient(url: webSocketURL, configuration: .init(maxFrameSize: 1 << 20)) else {
            throw Error.invalidGatewayURL
        }

        await actor.run { actor in
            actor.webSocketTask = Task.detached { [unowned self] in
                await webSocketTaskMain(webSocket)
            }

            while actor.webSocketTask != nil && actor.state != .connected {
                await Task.yield()
            }
        }
    }

    public func run() async throws {
        try await connect()
        try await actor.webSocketTask?.value
    }

    private func webSocketTaskMain(_ webSocket: WebSocketClient) async {
        do {
            await actor.updateState(.connecting)
            try await webSocket.connect { inbound, outbound in
                await actor.run { actor in
                    actor.outbound = outbound
                    actor.state = .connected
                }

                for try await webSocketResponse in inbound {
                    debugPrint(webSocketResponse)
                    await handleWebSocketResponse(webSocketResponse)
                }

                await actor.run { actor in
                    actor.outbound = nil
                    actor.state = .disconnected
                }
            }

            await actor.reset()
        } catch {
            debugPrint(error)
        }
    }
}
