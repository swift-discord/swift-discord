//
//  GatewaySession+Actor.swift
//
//
//  Created by Jaehong Kang on 6/28/24.
//

import Foundation
import Dispatch
import WebSocketClient

extension GatewaySession {
    actor Actor {
        var webSocketSession: WebSocketSession? = nil
        var heartbeatInterval: TimeInterval = .leastNormalMagnitude
        var sequence: Int? = nil
        var heartbeatTimer: DispatchSourceTimer? = nil

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
