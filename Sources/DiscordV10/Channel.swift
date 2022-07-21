//
//  Channel.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord

public struct Channel: Equatable, Hashable, Identifiable, Sendable {
    public enum `Type`: Int, Equatable, Hashable, Sendable, Codable {
        case guildText = 0
        case dm
        case guildVoice
        case groupDM
        case guildCategory
        case guildNews
        case guildNewsThread = 10
        case guildPublicThread
        case guildPrivateThread
        case guildStageVoice
        case guildDirectory
        case guildForum
    }

    public struct Overwrite: Equatable, Hashable, Identifiable, Sendable, Codable {
        public enum `Type`: Int, Equatable, Hashable, Sendable, Codable {
            case role = 0
            case member
        }

        public let id: Snowflake
        public let type: Unknown<`Type`>
        public let allow: String
        public let deny: String
    }

    public enum VideoQualityMode: Int, Equatable, Hashable, Sendable, Codable {
        case auto = 1
        case full
    }

    public struct ThreadMetadata: Equatable, Hashable, Sendable, Codable {
        public let archived: Bool
        public let autoArchiveDuration: Int
        public let archiveTimestamp: Date
        public let locked: Bool
        public let invitable: Bool?
        public let createTimestamp: Date?
    }

    public struct ThreadMember: Equatable, Hashable, Sendable {
        public let id: Snowflake?
        public let userID: Snowflake?
        public let joinTimestamp: Date
        public let flags: Int
    }

    public struct Flags: OptionSet, Equatable, Hashable, Sendable, Codable {
        public static let pinned = Self.init(rawValue: 1 << 1)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public let id: Snowflake

    public let type: Unknown<`Type`>

    public let guildID: Snowflake?

    public let position: Int?
    
    public let permissionOverwrites: [Overwrite]?

    public let name: String?
    public let topic: String?

    public let isNSFW: Bool?

    public let lastMessageID: Snowflake?

    public let bitrate: Int?
    public let userLimit: Int?
    public let rateLimitPerUser: Int?

    public let recipients: [User]?

    public let icon: String?

    public let ownerID: Snowflake?
    public let applicationID: Snowflake?
    public let parentID: Snowflake?

    public let lastPinTimestamp: Date?

    public let rtcRegion: String?
    public let videoQualityMode: Unknown<VideoQualityMode>?

    public let messageCount: Int?
    public let memberCount: Int?

    public let threadMetadata: ThreadMetadata?
    public let member: ThreadMember?

    public let defaultAutoArchiveDuration: Int?
    public let permissions: String?
    public let flags: Flags?
}


extension Channel.ThreadMember: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case joinTimestamp
        case flags
    }
}

extension Channel: Codable {
    enum CodingKeys: String, CodingKey {
        case id

        case type

        case guildID = "guildId"

        case position

        case permissionOverwrites

        case name
        case topic

        case isNSFW = "nsfw"

        case lastMessageID = "lastMessageId"

        case bitrate
        case userLimit
        case rateLimitPerUser

        case recipients

        case icon

        case ownerID = "ownerId"
        case applicationID = "applicationId"
        case parentID = "parentId"

        case lastPinTimestamp

        case rtcRegion
        case videoQualityMode

        case messageCount
        case memberCount

        case threadMetadata
        case member

        case defaultAutoArchiveDuration
        case permissions
        case flags
    }
}
