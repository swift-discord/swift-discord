//
//  Voice+State.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import Foundation
import Snowflake

extension Voice {
    public struct State: Sendable, Equatable, Hashable {
        public let guildID: Snowflake?
        public let channelID: Snowflake?
        public let userID: Snowflake
        public let sessionID: String
        public let deaf: Bool
        public let mute: Bool
        public let selfDeaf: Bool
        public let selfMute: Bool
        public let selfStream: Bool?
        public let selfVideo: Bool
        public let suppress: Bool
        public let requestToSpeakTimestamp: Date?
    }
}

extension Voice.State: Decodable {
    public enum CodingKeys: String, CodingKey {
        case guildID = "guildId"
        case channelID = "channelId"
        case userID = "userId"
        case sessionID = "sessionId"
        case deaf
        case mute
        case selfDeaf
        case selfMute
        case selfStream
        case selfVideo
        case suppress
        case requestToSpeakTimestamp
    }
}
