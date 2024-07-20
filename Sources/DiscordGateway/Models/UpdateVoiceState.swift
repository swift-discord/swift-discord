//
//  UpdateVoiceState.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

import Snowflake

public struct UpdateVoiceState: Hashable, Sendable {
    public var guildID: Snowflake
    public var channelID: Snowflake?
    public var selfMute: Bool
    public var selfDeaf: Bool

    public init(
        guildID: Snowflake,
        channelID: Snowflake? = nil,
        selfMute: Bool,
        selfDeaf: Bool
    ) {
        self.guildID = guildID
        self.channelID = channelID
        self.selfMute = selfMute
        self.selfDeaf = selfDeaf
    }
}

extension UpdateVoiceState: Codable {
    public enum CodingKeys: String, CodingKey {
        case guildID = "guildId"
        case channelID = "channelId"
        case selfMute
        case selfDeaf
    }
}
