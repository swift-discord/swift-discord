//
//  Guild.Feature.swift
//  
//
//  Created by Mina Her on 2022/07/31.
//

extension Guild {

    @frozen
    public struct Feature: Codable, Hashable, RawRepresentable, Sendable {

        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension Guild.Feature {

    public static let animatedBanner: Self = "ANIMATED_BANNER"

    public static let animatedIcon: Self = "ANIMATED_ICON"

    public static let autoModeration: Self = "AUTO_MODERATION"

    public static let banner: Self = "BANNER"

    public static let community: Self = "COMMUNITY"

    public static let discoverable: Self = "DISCOVERABLE"

    public static let featurable: Self = "FEATURABLE"

    public static let inviteSplash: Self = "INVITE_SPLASH"

    public static let memberVerificationGateEnabled: Self = "MEMBER_VERIFICATION_GATE_ENABLED"

    public static let monetizationEnabled: Self = "MONETIZATION_ENABLED"

    public static let moreStickers: Self = "MORE_STICKERS"

    public static let news: Self = "NEWS"

    public static let partnered: Self = "PARTNERED"

    public static let previewEnabled: Self = "PREVIEW_ENABLED"

    public static let privateThreads: Self = "PRIVATE_THREADS"

    public static let roleIcons: Self = "ROLE_ICONS"

    public static let ticketedEventsEnabled: Self = "TICKETED_EVENTS_ENABLED"

    public static let vanityURL: Self = "VANITY_URL"

    public static let verified: Self = "VERIFIED"

    public static let vipRegions: Self = "VIP_REGIONS"

    public static let welcomeScreenEnabled: Self = "WELCOME_SCREEN_ENABLED"
}

extension Guild.Feature: Equatable {

    public static func == <S>(lhs: Self, rhs: S) -> Bool
    where S: StringProtocol {
        lhs.rawValue == rhs
    }

    public static func == <S>(lhs: S, rhs: Self) -> Bool
    where S: StringProtocol {
        lhs == rhs.rawValue
    }
}

extension Guild.Feature: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        rawValue = value
    }
}

extension Guild.Feature: LosslessStringConvertible {

    public var description: String {
        rawValue
    }

    public init(_ description: String) {
        rawValue = description
    }
}
