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
            let payload: GatewayDynamicPayload = try {
                switch message {
                case .string(let string):
                    return try jsonDecoder.decode(GatewayDynamicPayload.self, from: Data(string.utf8))
                case .data(let data):
                    return try jsonDecoder.decode(GatewayDynamicPayload.self, from: data) // TODO: Handle compression.
                }
            }()

            dump(payload)

            switch payload.opcode {
            case .hello:
                let heartbeatInterval = payload.data?.object?["heartbeat_interval"]??.number?.int.flatMap {
                    TimeInterval($0)
                }

                self.heartbeatInterval = heartbeatInterval ?? self.heartbeatInterval
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

        let payload = GatewayDynamicPayload(
            opcode: .identify,
            data: .object([
                "token": .string(authenticationToken),
                "compress": .bool(false),
                "properties": .object([
                    "os": .string(os),
                    "browser": .string("swift-discord"),
                    "device": .string("swift-discord")
                ]),
                "intents": .number(.int(513))
            ]),
            sequence: nil,
            type: nil
        )

        try await send(payload: payload)
    }
}
