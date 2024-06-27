//
//  Guild.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation

public struct Guild: Equatable, Hashable, Identifiable, Sendable {
    public enum VerificationLevel: Int, Equatable, Hashable, Sendable, Codable {
        case none = 0
        case low
        case medium
        case high
        case veryHigh
    }

    public enum DefaultMessageNotificationLevel: Int, Equatable, Hashable, Sendable, Codable {
        case allMessages = 0
        case onlyMentions
    }

    public enum ExplicitContentFilterLevel: Int, Equatable, Hashable, Sendable, Codable {
        case disabled = 0
        case membersWithoutRoles
        case allMembers
    }

    public enum MFALevel: Int, Equatable, Hashable, Sendable, Codable {
        case none = 0
        case elevated
    }

    public enum NSFWLevel: Int, Equatable, Hashable, Sendable, Codable {
        case `default` = 0
        case explicit
        case safe
        case ageRestricted
    }

    public enum PremiumTier: Int, Equatable, Hashable, Sendable, Codable {
        case none = 0
        case tier1
        case tier2
        case tier3
    }

    public struct SystemChannelFlags: OptionSet, Equatable, Hashable, Sendable, Codable {
        public static let suppressJoinNotifications = Self.init(rawValue: 1 << 0)
        public static let suppressPremiumSubscriptions = Self.init(rawValue: 1 << 1)
        public static let suppressGuildReminderNotifications = Self.init(rawValue: 1 << 2)
        public static let suppressJoinNotificationsReplies = Self.init(rawValue: 1 << 3)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public let id: Snowflake

    public let isUnavailable: Bool?

    public let name: String?
    public let icon: String?
    public let splash: String?
    public let discoverySplash: String?

    public let isOwner: Bool?
    public let ownerID: Snowflake?

    public let permissions: String?

    public let afkChannelID: Snowflake?
    public let afkTimeout: Int?

    public let isWidgetEnabled: Bool?
    public let widgetChannelID: Snowflake?

    public let verificationLevel: Unknown<VerificationLevel>?

    public let defaultMessageNotifications: Unknown<DefaultMessageNotificationLevel>?

    public let explicitContentFilter: Unknown<ExplicitContentFilterLevel>?

    public let roles: [Role]?
    public let emojis: [Emoji]?
    public let features: Set<Feature>?

    public let mfaLevel: Unknown<MFALevel>?

    public let applicationID: Snowflake?

    public let systemChannelID: Snowflake?
    public let systemChannelFlags: SystemChannelFlags?

    public let rulesChannelID: Snowflake?

    public let maxPresences: Int?
    public let maxMembers: Int?

    public let vanityURLCode: String?
    public let description: String?
    public let banner: String?

    public let premiumTier: Unknown<PremiumTier>?
    public let premiumSubscriptionCount: Int?

    public let preferredLocale: String?

    public let publicUpdatesChannelID: Snowflake?

    public let maxVideoChannelUsers: Int?

    public let approximateMemberCount: Int?
    public let approximatePresenceCount: Int?

    public let welcomeScreen: WelcomeScreen?

    public let nsfwLevel: Unknown<NSFWLevel>?

    public let stickers: [Sticker]?

    public let isPremiumProgressBarEnabled: Bool?
}

extension Guild: Codable {
    enum CodingKeys: String, CodingKey {
        case id

        case isUnavailable = "unavailable"

        case name
        case icon
        case splash
        case discoverySplash

        case isOwner = "owner"
        case ownerID = "ownerId"

        case permissions

        case afkChannelID = "afkChannelId"
        case afkTimeout

        case isWidgetEnabled = "widgetEnabled"
        case widgetChannelID = "widgetChannelId"

        case verificationLevel

        case defaultMessageNotifications

        case explicitContentFilter

        case roles
        case emojis
        case features

        case mfaLevel

        case applicationID = "applicationId"

        case systemChannelID = "systemChannelId"
        case systemChannelFlags

        case rulesChannelID = "rulesChannelId"

        case maxPresences
        case maxMembers

        case vanityURLCode = "vanityUrlCode"
        case description
        case banner

        case premiumTier
        case premiumSubscriptionCount

        case preferredLocale

        case publicUpdatesChannelID = "publicUpdatesChannelId"

        case maxVideoChannelUsers

        case approximateMemberCount
        case approximatePresenceCount

        case welcomeScreen

        case nsfwLevel

        case stickers

        case isPremiumProgressBarEnabled = "premiumProgressBarEnabled"

    }
}
