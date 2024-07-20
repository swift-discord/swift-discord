//
//  VoiceServerUpdate.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

import Snowflake

public struct VoiceServerUpdate: Hashable, Sendable {
    public let token: String
    public let guildID: Snowflake
    public let endpoint: String?
}

extension VoiceServerUpdate: Codable {
    public enum CodingKeys: String, CodingKey {
        case token
        case guildID = "guildId"
        case endpoint
    }
}
