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
    func handleWebSocketResponse(_ webSocketResponse: WebSocketClient.Response) async {
        do {
            let data: Data
            switch webSocketResponse.data {
            case .ping(let string):
                data = Data(string.utf8)
            case .text(let string):
                data = Data(string.utf8)
            case .binary(let buffer):
                data = Data(buffer)
            case .close:
                return
            case nil:
                dump(webSocketResponse.frame)
                return
            }

            let payload = try JSONDecoder.discord.decode(GatewayShallowPayload.self, from: data)
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
            case .dispatch:
                await self.actor.run { actor in
                    actor.state = .ready
                }
            default:
                dump(webSocketResponse.data)
            }
        } catch {
            debugPrint(error)
        }
    }

}

extension GatewaySession {
    public func send<D>(payload: GatewayPayload<D>, waitsForReady: Bool = true) async throws where D: Encodable {
        let encoder: any TopLevelEncoder<Foundation.Data> = {
            switch configuration.encoding {
            case .json:
                JSONEncoder.discord
            }
        }()

        let data = try encoder.encode(payload)

        let outbound = await actor.run { actor in
            if waitsForReady {
                while actor.webSocketTask != nil && actor.state != .ready {
                    await Task.yield()
                }
            } else {
                while actor.webSocketTask != nil && actor.state == .connecting {
                    await Task.yield()
                }
            }

            return actor.outbound
        }

        try await outbound?.write(.text(String(decoding: data, as: UTF8.self)))
    }
}

extension GatewaySession {
    public func updatePresence(idleSince: Date? = nil, activities: [Activity], status: PresenceUpdate.Status, afk: Bool) async throws {
        let payload =
            GatewayPayload(
                opcode: .presenceUpdate,
                data: PresenceUpdate(
                    sinceDate: idleSince,
                    activities: activities,
                    status: status,
                    afk: afk
                ),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
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

        try await send(payload: payload, waitsForReady: false)
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

        try await send(payload: payload, waitsForReady: false)
    }
}
