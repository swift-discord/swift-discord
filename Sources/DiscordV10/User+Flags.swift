//
//  User+Flags.swift
//  
//
//  Created by 강재홍 on 2022/07/19.
//

import Foundation

extension User {
    public struct Flags: OptionSet {
        static let staff = Self.init(rawValue: 1 << 0)
        static let partner = Self.init(rawValue: 1 << 1)
        static let hypeSquad = Self.init(rawValue: 1 << 2)
        static let bugHunterLevel1 = Self.init(rawValue: 1 << 3)
        static let hypeSquadOnlineHouse1 = Self.init(rawValue: 1 << 6)
        static let hypeSquadOnlineHouse2 = Self.init(rawValue: 1 << 7)
        static let hypeSquadOnlineHouse3 = Self.init(rawValue: 1 << 8)
        static let premiumEarlySupporter = Self.init(rawValue: 1 << 9)
        static let teamPseudoUser = Self.init(rawValue: 1 << 10)
        static let bugHunterLevel2 = Self.init(rawValue: 1 << 14)
        static let verifiedBot = Self.init(rawValue: 1 << 16)
        static let verifiedDeveloper = Self.init(rawValue: 1 << 17)
        static let certifiedModerator = Self.init(rawValue: 1 << 18)
        static let botHttpInteractions = Self.init(rawValue: 1 << 19)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension User.Flags: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        self.rawValue = try container.decode(RawValue.self)
    }
}

extension User.Flags: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(rawValue)
    }
}
