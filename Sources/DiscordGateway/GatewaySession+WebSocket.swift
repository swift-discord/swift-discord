//
//  GatewaySession+WebSocket.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Dispatch
import Foundation
import DiscordCore
import WebSocketClient

extension GatewaySession {
    var os: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(Linux)
        return "Linux"
        #elseif os(Windows)
        return "Windows"
        #elseif os(Android)
        return "Android"
        #else
        return "Unknown"
        #endif
    }
}

extension GatewaySession: WebSocketSessionDelegate {
    public func didReceiveMessage(_ message: WebSocketSession.Message, context: Context) {
        Task {
            do {
                let jsonDecoder = JSONDecoder()
                let data: Foundation.Data = {
                    switch message {
                    case .string(let string):
                        return .init(string.utf8)
                    case .data(let data):
                        return .init(data)
                        // TODO: Handle compression.
                    }
                }()
                let payload = try jsonDecoder.decode(GatewayShallowPayload.self, from: data)
                if let sequence = payload.sequence {
                    await self.actor.updateSequence(sequence)
                }

                switch payload.opcode {
                case .hello:
                    let payload = try JSONDecoder.discord.decode(GatewayPayload<Hello>.self, from: data)
                    if let heartbeatInterval = payload.data?.heartbeatInterval {
                        await self.actor.run {
                            $0.heartbeatInterval = heartbeatInterval
                        }
                        print("heartbeat interval set to \(heartbeatInterval) secs.")
                    }
                    await self.actor.stopHeartbeatTimer()
                    await self.actor.startHeartbeatTimer(interval: self.actor.heartbeatInterval, session: self)
                    try await identify()
                case .heartbeatACK:
                    await self.actor.stopHeartbeatTimer()
                    await self.actor.startHeartbeatTimer(interval: self.actor.heartbeatInterval, session: self)
                    print(payload.opcode)
                default:
                    dump(message)
                }
            } catch {
                debugPrint(error)
            }
        }
    }

    public func didClose(context: Context) {
        Task {
            await self.actor.run {
                $0.stopHeartbeatTimer()
                $0.heartbeatInterval = .infinity
                $0.sequence = nil
            }
        }
    }
}

extension GatewaySession {
    func send<D>(payload: GatewayPayload<D>) async throws where D: Encodable {
        guard let webSocketSession = await actor.webSocketSession else {
            return
        }

        let jsonEncoder = JSONEncoder.discord

        let data = try jsonEncoder.encode(payload)

        try await webSocketSession.send(.string(String(decoding: data, as: UTF8.self)))
    }

    func heartbeat() async throws {
        let payload = await GatewayPayload<Int64>(
            opcode: .heartbeat,
            data: actor.sequence.flatMap({.init($0)}),
            sequence: nil,
            type: nil
        )

        try await send(payload: payload)
    }

    func identify() async throws {
        guard let authenticationToken = await restSession.oAuth2Credential?.accessToken else {
            return
        }

        let payload =
            GatewayPayload(
                opcode: .identify,
                data: Identify(
                    token: authenticationToken,
                    properties: .init(
                        os: os,
                        browser: "swift-discord",
                        device: "swift-discord"),
                    intents: [.guilds, .guildMessages]),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
    }
}
