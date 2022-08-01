//
//  GatewaySession+WebSocket.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation
import DiscordCore
import WebSocket

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
    public nonisolated func didReceiveMessage(_ message: WebSocketSession.Message, context: Context) {
        Task {
            await _didReceiveMessage(message, context: context)
        }
    }

    func _didReceiveMessage(_ message: WebSocketSession.Message, context: Context) async {
        do {
            let jsonDecoder = JSONDecoder()
            let data: Data = {
                switch message {
                case .string(let string):
                    return .init(string.utf8)
                case .data(let data):
                    return data
                    // TODO: Handle compression.
                }
            }()
            let payload = try jsonDecoder.decode(GatewayShallowPayload.self, from: data)

            dump(payload)

            switch payload.opcode {
            case .hello:
                let payload = try JSONDecoder.discord.decode(GatewayPayload<Hello>.self, from: data)
                if let heartbeatInterval = payload.data?.heartbeatInterval {
                    self.heartbeatInterval = heartbeatInterval
                }
                self.lastHeartbeatACKDate = Date()

                try await identify()
            case .heartbeatACK:
                self.lastHeartbeatACKDate = Date()
            default:
                dump(message)
            }

            sequence = payload.sequence ?? sequence

            if Date() >= lastHeartbeatACKDate.addingTimeInterval(heartbeatInterval) {
                try await heartbeat()
            }
        } catch {
            debugPrint(error)
        }
    }
}

extension GatewaySession {
    func send<D>(payload: GatewayPayload<D>) async throws where D: Encodable {
        guard let webSocketSession = webSocketSession else {
            return
        }

        let jsonEncoder = JSONEncoder.discord

        let data = try jsonEncoder.encode(payload)

        try await webSocketSession.send(.string(String(decoding: data, as: UTF8.self)))
    }

    func heartbeat() async throws {
        let payload = GatewayDynamicPayload(
            opcode: .heartbeat,
            data: sequence.flatMap { .number(.int(Int64($0))) },
            sequence: nil,
            type: nil
        )

        try await send(payload: payload)
    }

    func identify() async throws {
        guard let authenticationToken = authenticationToken else {
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
                    intents: 513),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
    }
}
