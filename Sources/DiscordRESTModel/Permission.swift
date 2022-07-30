//
//  Permission.swift
//  
//
//  Created by Mina Her on 2022/07/30.
//

public struct Permission: Hashable, OptionSet, Sendable {

    public var rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

extension Permission {

    public static let createInstantInvite: Self = .init(1 << 0)

    public static let kickMembers: Self = .init(1 << 1)

    public static let banMembers: Self = .init(1 << 2)

    public static let administrator: Self = .init(1 << 3)

    public static let manageChannels: Self = .init(1 << 4)

    public static let manageGuild: Self = .init(1 << 5)

    public static let addReactions: Self = .init(1 << 6)

    public static let viewAuditLog: Self = .init(1 << 7)

    public static let prioritySpeaker: Self = .init(1 << 8)

    public static let stream: Self = .init(1 << 9)

    public static let viewChannel: Self = .init(1 << 10)

    public static let sendMessages: Self = .init(1 << 11)

    public static let sendTTSMessages: Self = .init(1 << 12)

    public static let manageMessages: Self = .init(1 << 13)

    public static let embedLinks: Self = .init(1 << 14)

    public static let attachFiles: Self = .init(1 << 15)

    public static let readMessageHistory: Self = .init(1 << 16)

    public static let mentionEveryone: Self = .init(1 << 17)

    public static let useExternalEmojis: Self = .init(1 << 18)

    public static let viewGuildInsights: Self = .init(1 << 19)

    public static let connect: Self = .init(1 << 20)

    public static let speak: Self = .init(1 << 21)

    public static let muteMembers: Self = .init(1 << 22)

    public static let deafenMembers: Self = .init(1 << 23)

    public static let moveMembers: Self = .init(1 << 24)

    public static let useVAD: Self = .init(1 << 25)

    public static let changeNickname: Self = .init(1 << 26)

    public static let manageNicknames: Self = .init(1 << 27)

    public static let manageRoles: Self = .init(1 << 28)

    public static let manageWebhooks: Self = .init(1 << 29)

    public static let manageEmojisAndStickers: Self = .init(1 << 30)

    public static let useApplicationCommands: Self = .init(1 << 31)

    public static let requestToSpeak: Self = .init(1 << 32)

    public static let manageEvents: Self = .init(1 << 33)

    public static let manageThreads: Self = .init(1 << 34)

    public static let createPublicThreads: Self = .init(1 << 35)

    public static let createPrivateThreads: Self = .init(1 << 36)

    public static let useExternalStickers: Self = .init(1 << 37)

    public static let sendMessagesInThreads: Self = .init(1 << 38)

    public static let useEmbeddedActivities: Self = .init(1 << 39)

    public static let moderateMembers: Self = .init(1 << 40)

    private init(_ uint64Value: UInt64) {
        rawValue = uint64Value
    }
}

extension Permission: Codable {

    public init(from decoder: Decoder) throws {
        switch decoder.permissionDecodingStrategy {
        case .custom(let decode):
            self = try decode(decoder)
        case .string:
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            guard let uint64Value = UInt64(stringValue)
            else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: container.codingPath,
                        debugDescription: "Expected to decode string representation of UInt64 but found other string instead."))
            }
            rawValue = uint64Value
        case .uint64:
            let container = try decoder.singleValueContainer()
            rawValue = try container.decode(UInt64.self)
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch encoder.permissionEncodingStrategy {
        case .custom(let encode):
            try encode(self, encoder)
        case .string:
            var container = encoder.singleValueContainer()
            try container.encode(rawValue.description)
        case .uint64:
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
}
