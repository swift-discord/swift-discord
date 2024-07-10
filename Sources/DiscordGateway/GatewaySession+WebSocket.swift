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
                        os: configuration.osInfo,
                        browser: configuration.browserInfo,
                        device: configuration.deviceInfo),
                    intents: [.guilds, .guildMessages]),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
    }
}
