//
//  GatewaySession+WebSocket.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Dispatch
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

extension GatewaySession {

    private func startHeartbeatTimer(interval: TimeInterval) {
        guard heartbeatTimer == nil
        else {
            return
        }
        let heartbeatTimer = DispatchSource.makeTimerSource()
        heartbeatTimer.schedule(wallDeadline: .now() + interval, repeating: interval)
        heartbeatTimer.setEventHandler {
            Task {
                [weak self] in
                try await self?.heartbeat()
            }
        }
        heartbeatTimer.activate()
        self.heartbeatTimer = heartbeatTimer
    }

    private func stopHeartbeatTimer() {
        if let heartbeatTimer = heartbeatTimer {
            self.heartbeatTimer = nil
            if !heartbeatTimer.isCancelled {
                heartbeatTimer.cancel()
            }
        }
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
            if let sequence = payload.sequence {
                self.sequence = sequence
            }

            switch payload.opcode {
            case .hello:
                let payload = try JSONDecoder.discord.decode(GatewayPayload<Hello>.self, from: data)
                if let heartbeatInterval = payload.data?.heartbeatInterval {
                    self.heartbeatInterval = heartbeatInterval
                    print("heartbeat interval set to \(heartbeatInterval) secs.")
                }
                stopHeartbeatTimer()
                startHeartbeatTimer(interval: heartbeatInterval)
                try await identify()
            case .heartbeatACK:
                stopHeartbeatTimer()
                startHeartbeatTimer(interval: heartbeatInterval)
                print(payload.opcode)
            default:
                dump(message)
            }
        } catch {
            debugPrint(error)
        }
    }

    public nonisolated func didClose(context: Context) {
        Task {
            await _didClose(context: context)
        }
    }

    private func _didClose(context: Context) async {
        stopHeartbeatTimer()
        heartbeatInterval = .infinity
        sequence = nil
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
        let payload = GatewayPayload<Int64>(
            opcode: .heartbeat,
            data: sequence.flatMap({.init($0)}),
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
                    intents: [.guilds, .guildMessages]),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
    }
}
