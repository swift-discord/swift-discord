//
//  VoiceIdentify.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import Snowflake

public struct VoiceIdentify: Sendable {
    public var serverID: Snowflake
    public var userID: Snowflake
    public var sessionID: String
    public var token: String
}

extension VoiceIdentify: Encodable {
    public enum CodingKeys: String, CodingKey {
        case serverID = "serverId"
        case userID = "userId"
        case sessionID = "sessionId"
        case token
    }
}
