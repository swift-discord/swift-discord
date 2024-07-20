//
//  GatewaySession+Actor.swift
//
//
//  Created by Jaehong Kang on 6/28/24.
//

import Foundation
import Dispatch
import WebSocketClient
import DiscordCore

extension GatewaySession {
    actor Actor {
        var state: State = .disconnected
        var webSocketTask: Task<Void, Swift.Error>?
        var heartbeatInterval: TimeInterval = .leastNormalMagnitude
        var sequence: Int? = nil
        var heartbeatTimer: DispatchSourceTimer? = nil
        var outbound: WebSocketClient.Outbound? = nil
        var eventHandlers: Set<Weak<EventHandler>> = []

        deinit {
            webSocketTask?.cancel()
        }
    }
}

extension GatewaySession.Actor {
    func updateState(_ state: GatewaySession.State) {
        self.state = state
    }

    func reset() {
        self.stopHeartbeatTimer()
        self.heartbeatInterval = .infinity
        self.sequence = nil
        self.webSocketTask = nil
    }
}

extension GatewaySession.Actor {
    func updateSequence(_ sequence: Int) {
        if let oldSequence = self.sequence {
            self.sequence = max(oldSequence, sequence)
        } else {
            self.sequence = sequence
        }
    }
}

extension GatewaySession.Actor {
    func startHeartbeatTimer(interval: TimeInterval, session: GatewaySession) {
        guard heartbeatTimer == nil
        else {
            return
        }
        let heartbeatTimer = DispatchSource.makeTimerSource()
        heartbeatTimer.schedule(wallDeadline: .now() + interval, repeating: interval)
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
