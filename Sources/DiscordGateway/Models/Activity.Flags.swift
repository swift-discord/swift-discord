//
//  Activity.Flags.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

extension Activity {

    public struct Flags: Codable, Hashable, OptionSet, Sendable {

        public var rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

extension Activity.Flags {

    public static let instance: Self = .init(1 << 0)

    public static let join: Self = .init(1 << 1)

    public static let spectate: Self = .init(1 << 2)

    public static let joinRequest: Self = .init(1 << 3)

    public static let sync: Self = .init(1 << 4)

    public static let play: Self = .init(1 << 5)

    public static let partyPrivacyFriends: Self = .init(1 << 6)

    public static let partyPrivacyVoiceChannel: Self = .init(1 << 7)

    public static let embedded: Self = .init(1 << 8)

    private init(_ uintValue: UInt) {
        rawValue = uintValue
    }
}
