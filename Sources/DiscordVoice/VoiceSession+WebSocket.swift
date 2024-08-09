//
//  VoiceSession+WebSocket.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import Foundation
import WebSocketClient
import DiscordCore

extension VoiceSession {
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
            case .close, nil:
                return
            }

            let payload = try JSONDecoder.discord.decode(VoiceGatewayDynamicPayload.self, from: data)

            switch payload.opcode {
            case .hello:
                let payload = try VoiceGatewayPayload<VoiceHello>(payload)
                await self.actor.updateHeartbeatInterval(payload.data.heartbeatInterval)
                await self.actor.stopHeartbeatTimer()
                await self.actor.startHeartbeatTimer(session: self)
                try await identify()
            case .heartbeatACK:
                await self.actor.stopHeartbeatTimer()
                await self.actor.startHeartbeatTimer(session: self)
            case .ready:
                let payload = try VoiceGatewayPayload<VoiceReady>(payload)
                await self.actor.run { actor in
                    actor.state = .ready
                }
            default:
                // TODO: Handle Events
                break
            }
        } catch {
            debugPrint(error)
        }
    }
}

extension VoiceSession {
    public func send<D>(payload: VoiceGatewayPayload<D>, waitsForReady: Bool = true) async throws where D: Encodable {
        let data = try JSONEncoder.discord.encode(payload)

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
