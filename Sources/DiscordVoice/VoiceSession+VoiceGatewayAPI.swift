//
//  VoiceSession+VoiceGatewayAPI.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import Foundation

extension VoiceSession {
    func identify() async throws {
        guard 
            let voiceStateUpdate = await actor.voiceStateUpdate,
            let voiceServerUpdate = await actor.voiceServerUpdate
        else {
            throw Error.notAuthenticated
        }

        let payload =
            VoiceGatewayPayload(
                opcode: .identify,
                data: VoiceIdentify(
                    serverID: voiceServerUpdate.guildID,
                    userID: voiceStateUpdate.userID,
                    sessionID: voiceStateUpdate.sessionID,
                    token: voiceServerUpdate.token
                )
            )

        try await send(payload: payload, waitsForReady: false)
    }
}

extension VoiceSession {
    func heartbeat() async throws {
        let payload = VoiceGatewayPayload<Int>(
            opcode: .heartbeat,
            data: time(nil)
        )

        try await send(payload: payload, waitsForReady: false)
    }
}
