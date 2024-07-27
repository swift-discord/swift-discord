//
//  VoiceSession+Actor.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import Foundation
import Dispatch
import WebSocketClient
import Snowflake
import DiscordGateway

extension VoiceSession {
    actor Actor {
        var gatewaySessionEventHandler: GatewaySession.EventHandler?
        var state: State = .disconnected
        var voiceStateUpdate: VoiceStateUpdate?
        var voiceServerUpdate: VoiceServerUpdate?
        var heartbeatInterval: Int = .max
        var heartbeatTimer: DispatchSourceTimer? = nil
        var webSocketTask: Task<Void, Swift.Error>?
        var outbound: WebSocketClient.Outbound? = nil
    }
}

extension VoiceSession.Actor {
    func updateState(_ state: VoiceSession.State) {
        self.state = state
    }

    func reset() {
        self.stopHeartbeatTimer()
        self.heartbeatInterval = .max
        self.webSocketTask = nil
    }
}

extension VoiceSession.Actor {
    func updateHeartbeatInterval(_ interval: Int) {
        heartbeatInterval = interval
    }

    func startHeartbeatTimer(session: VoiceSession) {
        guard heartbeatTimer == nil else {
            return
        }

        let heartbeatTimer = DispatchSource.makeTimerSource()
        heartbeatTimer.schedule(
            wallDeadline: .now() + .milliseconds(heartbeatInterval),
            repeating: Double(heartbeatInterval * Int(MSEC_PER_SEC))
        )
        heartbeatTimer.setEventHandler { [weak session] in
            Task { [session] in
                try await session?.heartbeat()
            }
        }
        heartbeatTimer.activate()
        self.heartbeatTimer = heartbeatTimer
    }

    func stopHeartbeatTimer() {
        if let heartbeatTimer = heartbeatTimer {
            self.heartbeatTimer = nil
            if !heartbeatTimer.isCancelled {
                heartbeatTimer.cancel()
            }
        }
    }
}
