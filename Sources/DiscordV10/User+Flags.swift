//
//  User+Flags.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation

extension User {
    public struct Flags: OptionSet, Codable, Sendable {
        public static let staff = Self.init(rawValue: 1 << 0)
        public static let partner = Self.init(rawValue: 1 << 1)
        public static let hypeSquad = Self.init(rawValue: 1 << 2)
        public static let bugHunterLevel1 = Self.init(rawValue: 1 << 3)
        public static let hypeSquadOnlineHouse1 = Self.init(rawValue: 1 << 6)
        public static let hypeSquadOnlineHouse2 = Self.init(rawValue: 1 << 7)
        public static let hypeSquadOnlineHouse3 = Self.init(rawValue: 1 << 8)
        public static let premiumEarlySupporter = Self.init(rawValue: 1 << 9)
        public static let teamPseudoUser = Self.init(rawValue: 1 << 10)
        public static let bugHunterLevel2 = Self.init(rawValue: 1 << 14)
        public static let verifiedBot = Self.init(rawValue: 1 << 16)
        public static let verifiedDeveloper = Self.init(rawValue: 1 << 17)
        public static let certifiedModerator = Self.init(rawValue: 1 << 18)
        public static let botHttpInteractions = Self.init(rawValue: 1 << 19)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
