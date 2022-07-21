//
//  Guild+WelcomeScreen.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord

extension Guild {
    public struct WelcomeScreen: Equatable, Hashable, Sendable, Codable {
        public struct Channel: Equatable, Hashable, Sendable {
            public let channelID: Snowflake
            public let description: String

            public let emojiID: Snowflake?
            public let emojiName: String?
        }

        public let description: String?
        public let welcomeChannels: [Channel]
    }
}

extension Guild.WelcomeScreen.Channel: Codable {
    enum CodingKeys: String, CodingKey {
        case channelID = "channelId"
        case description

        case emojiID = "emojiId"
        case emojiName
    }
}
