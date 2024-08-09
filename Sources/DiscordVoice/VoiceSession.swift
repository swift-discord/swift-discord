//
//  VoiceSession.swift
//  
//
//  Created by Jaehong Kang on 7/20/24.
//

import Clibavcodec
import DiscordGateway
import AsyncAlgorithms
import Foundation
import Snowflake
import WebSocketClientFoundationCompat
import RTP

public final class VoiceSession: Sendable {
    public let configuration: Configuration
    public let gatewaySession: GatewaySession

    let actor = Actor()

    public init(
        configuration: Configuration,
        gatewaySession: GatewaySession
    ) async {
        self.configuration = configuration
        self.gatewaySession = gatewaySession
    }

    public func connect(
        for guildID: Snowflake,
        channelID: Snowflake,
        mute: Bool,
        deaf: Bool
    ) async throws {
        let shouldConnect = await actor.run { actor in
            guard case .disconnected = actor.state else {
                return false
            }

            actor.updateState(.connecting)

            return true
        }

        guard shouldConnect else {
            return
        }

        guard gatewaySession.configuration.intents.contains([.guilds, .guildVoiceStates]) else {
            throw Error.guildVoiceStatesIntentRequired
        }

        let gatewaySessionEventHandler = await gatewaySession.handleEvent { [weak self] in
            await self?.handleGatewayEvent($0)
        }

        await self.actor.run { actor in
            actor.gatewaySessionEventHandler = gatewaySessionEventHandler
        }

        try await gatewaySession.updateVoiceState(
            for: guildID,
            channelID: channelID,
            selfMute: mute,
            selfDeaf: deaf
        )
    }

    private func connect(to endpoint: String) async throws {
        guard var urlComponents = URLComponents(string: "wss://\(endpoint)") else {
            throw Error.invalidVoiceGatewayURL
        }

        var queryItems: [URLQueryItem] = []
        if let voiceAPIVersion = configuration.voiceAPIVersion {
            queryItems.append(.init(name: "v", value: voiceAPIVersion.versionString))
        }
        urlComponents.queryItems = queryItems

        let webSocketURL = urlComponents.url!
        guard let webSocket = WebSocketClient(url: webSocketURL, configuration: .init(maxFrameSize: 1 << 20)) else {
            throw Error.invalidVoiceGatewayURL
        }

        await actor.run { actor in
            actor.webSocketTask = Task.detached { [unowned self] in
                await webSocketTaskMain(webSocket)
            }
        }
    }

    public func run() async throws {
        try await withTaskCancellationHandler {
            try await actor.webSocketTask?.value
        } onCancel: {
            Task(priority: .high) {
                await actor.webSocketTask?.cancel()
            }
        }
    }

    private func webSocketTaskMain(_ webSocket: WebSocketClient) async {
        do {
            try await webSocket.connect { inbound, outbound in
                await actor.run { actor in
                    actor.outbound = outbound
                    actor.state = .connected
                }

                for try await webSocketResponse in inbound {
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

    private func handleGatewayEvent(_ payload: GatewayDynamicPayload) async {
        do {
            switch payload.opcode {
            case .dispatch where payload.type == "VOICE_STATE_UPDATE":
                let voiceStateUpdate = try GatewayPayload<VoiceStateUpdate>(payload)

                await actor.run { actor in
                    actor.voiceStateUpdate = voiceStateUpdate.data
                }
            case .dispatch where payload.type == "VOICE_SERVER_UPDATE":
                let voiceServerUpdate = try GatewayPayload<VoiceServerUpdate>(payload)

                try await actor.run { actor in
                    actor.voiceServerUpdate = voiceServerUpdate.data

                    switch actor.state {
                    case .connecting:
                        if let endpoint = voiceServerUpdate.data.endpoint {
                            try await connect(to: endpoint)
                        }
                    case .connected, .disconnected, .ready:
                        break // TODO: Handle server changes
                    }
                }
            default:
                break
            }
        } catch {
            debugPrint(error)
        }
    }
}
