//
//  Role.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord

public struct Role: Equatable, Hashable, Identifiable, Sendable {
    public struct Tags: Equatable, Hashable, Sendable {
        public let botID: Snowflake?
        public let integrationID: Snowflake?
        // TODO: premium_subscriber
    }

    public let id: Snowflake

    public let name: String

    public let color: Int
    public let hoist: Bool
    public let icon: String?
    public let unicodeEmoji: String?
    public let position: Int

    public let permissions: String

    public let isManaged: Bool
    public let isMentionable: Bool

    public let tags: Tags?
}

extension Role.Tags: Codable {
    enum CodingKeys: String, CodingKey {
        case botID = "botId"
        case integrationID = "integrationId"
    }
}

extension Role: Codable {
    enum CodingKeys: String, CodingKey {
        case id

        case name

        case color
        case hoist
        case icon
        case unicodeEmoji
        case position

        case permissions

        case isManaged = "managed"
        case isMentionable = "mentionable"

        case tags
    }
}
