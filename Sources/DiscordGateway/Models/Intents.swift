//
//  Intents.swift
//  
//
//  Created by Mina Her on 2022/08/02.
//

public struct Intents: Codable, Hashable, OptionSet, Sendable {

    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension Intents {

    public static let guilds: Self = .init(1 << 0)

    public static let guildMembers: Self = .init(1 << 1)

    public static let guildBans: Self = .init(1 << 2)

    public static let guildEmojisAndStickers: Self = .init(1 << 3)

    public static let guildIntegrations: Self = .init(1 << 4)

    public static let guildWebhooks: Self = .init(1 << 5)

    public static let guildInvites: Self = .init(1 << 6)

    public static let guildVoiceStates: Self = .init(1 << 7)

    public static let guildPresences: Self = .init(1 << 8)

    public static let guildMessages: Self = .init(1 << 9)

    public static let guildMessageReactions: Self = .init(1 << 10)

    public static let guildMessageTyping: Self = .init(1 << 11)

    public static let directMessages: Self = .init(1 << 12)

    public static let directMessageReactions: Self = .init(1 << 13)

    public static let directMessageTyping: Self = .init(1 << 14)

    public static let messageContent: Self = .init(1 << 15)

    public static let guildScheduledEvents: Self = .init(1 << 16)

    public static let autoModerationConfiguration: Self = .init(1 << 20)

    public static let autoModerationExecution: Self = .init(1 << 21)

    private init(_ uintValue: UInt) {
        rawValue = uintValue
    }
}
