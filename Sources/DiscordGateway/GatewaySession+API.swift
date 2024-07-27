//
//  GatewaySession+API.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

import Foundation
import Snowflake

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
    public func updateVoiceState(for guildID: Snowflake, channelID: Snowflake? = nil, selfMute: Bool, selfDeaf: Bool) async throws {
        let payload =
            GatewayPayload(
                opcode: .voiceStatusUpdate,
                data: UpdateVoiceState(
                    guildID: guildID,
                    channelID: channelID,
                    selfMute: selfMute,
                    selfDeaf: selfDeaf
                ),
                sequence: nil,
                type: nil)

        try await send(payload: payload)
    }
}
