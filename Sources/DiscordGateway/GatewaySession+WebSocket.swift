//
//  GatewaySession+WebSocket.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation
import NIOCore
import NIOPosix
import NIOHTTP1
import NIOWebSocket
#if canImport(NIOTransportServices)
import NIOTransportServices
import Network
#else
import NIOFoundationCompat
#endif

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

extension GatewaySession {
    func didReceiveMessage(frame: WebSocketFrame, context: ChannelHandlerContext) async {
        do {
            let jsonDecoder = JSONDecoder()
            let payload = try jsonDecoder.decode(GatewayPayload.self, from: frame.data)

            dump(payload)

            switch payload.opcode {
            case .hello:
                let heartbeatInterval = payload.data?.dictionaryValue?["heartbeat_interval"]?.intValue.flatMap {
                    TimeInterval($0)
                }

                self.heartbeatInterval = heartbeatInterval ?? self.heartbeatInterval
                self.lastHeartbeatACKDate = Date()

                try await identify()
            case .heartbeatACK:
                self.lastHeartbeatACKDate = Date()
            default:
                dump(frame)
                break
            }

            sequence = payload.sequence ?? sequence

            if Date() >= lastHeartbeatACKDate.addingTimeInterval(heartbeatInterval) {
                try await heartbeat()
            }
        } catch {
            debugPrint(error)
        }
    }

    func send(payload: GatewayPayload) async throws {
        guard let webSocketSession = webSocketSession else {
            return
        }

        let jsonEncoder = JSONEncoder.discord

        let data = try jsonEncoder.encode(payload)

        try await webSocketSession.send(opcode: .text, bytes: data)
    }

    func heartbeat() async throws {
        let payload = GatewayPayload(
            opcode: .heartbeat,
            data: sequence.flatMap { .int($0) },
            sequence: nil,
            type: nil
        )

        try await send(payload: payload)
    }

    func identify() async throws {
        guard let authenticationToken = authenticationToken else {
            return
        }

        let payload = GatewayPayload(
            opcode: .identify,
            data: .dictionary([
                "token": .string(authenticationToken),
                "properties": .dictionary([
                    "os": .string(os),
                    "browser": .string("swift-discord"),
                    "device": .string("swift-discord")
                ]),
                "intents": .int(7)
            ]),
            sequence: nil,
            type: nil
        )

        try await send(payload: payload)
    }
}
