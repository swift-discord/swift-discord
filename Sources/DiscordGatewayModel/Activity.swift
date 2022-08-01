//
//  Activity.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

import struct Foundation.Date
import struct Foundation.URL

public struct Activity: Hashable, Sendable {

    public var name: String

    public var type: ActivityType

    public var url: URL?

    public var creationDate: Date?

    public var timestamps: Timestamps?

    public var applicationID: Snowflake?

    public var details: String?

    public var state: String?

    public var emoji: Emoji?

    public var party: Party?

    public var assets: Assets?

    public var secrets: Secrets?

    public var isInstance: Bool?

    public var flags: Flags?

    public var buttons: [Button]?

    public init(
        name: String,
        type: ActivityType,
        url: URL? = nil,
        creationDate: Date,
        timestamps: Timestamps? = nil,
        applicationID: Snowflake? = nil,
        details: String? = nil,
        state: String? = nil,
        emoji: Emoji? = nil,
        party: Party? = nil,
        assets: Assets? = nil,
        secrets: Secrets? = nil,
        isInstance: Bool? = nil,
        flags: Flags? = nil,
        buttons: [Button]? = nil
    ) {
        self.name = name
        self.type = type
        self.url = url
        self.creationDate = creationDate
        self.timestamps = timestamps
        self.applicationID = applicationID
        self.details = details
        self.state = state
        self.emoji = emoji
        self.party = party
        self.assets = assets
        self.secrets = secrets
        self.isInstance = isInstance
        self.flags = flags
        self.buttons = buttons
    }
}

extension Activity {

    public struct Button: Hashable, Sendable {

        public var label: String

        public var url: URL

        public init(
            label: String,
            url: URL
        ) {
            self.label = label
            self.url = url
        }
    }

    public struct Emoji: Hashable, Sendable {

        public var name: String

        public var id: Snowflake?

        public var isAnimated: Bool?

        public init(
            name: String,
            id: Snowflake? = nil,
            isAnimated: Bool? = nil
        ) {
            self.name = name
            self.id = id
            self.isAnimated = isAnimated
        }
    }

    public struct Secrets: Hashable, Sendable {

        public var join: String?

        public var spectate: String?

        public var match: String?

        public init(
            join: String? = nil,
            spectate: String? = nil,
            match: String? = nil
        ) {
            self.join = join
            self.spectate = spectate
            self.match = match
        }
    }

    public struct Timestamps: Hashable, Sendable {

        public var startDate: Date?

        public var endDate: Date?

        public init(
            startDate: Date? = nil,
            endDate: Date? = nil
        ) {
            self.startDate = startDate
            self.endDate = endDate
        }
    }
}

extension Activity: Codable {

    private enum CodingKeys: String, CodingKey {

        case name

        case type

        case url

        case creationDate = "createdAt"

        case timestamps

        case applicationID = "applicationId"

        case details

        case state

        case emoji

        case party

        case assets

        case secrets

        case isInstance = "instance"

        case flags

        case buttons
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(ActivityType.self, forKey: .type)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        if let int64Value = try container.decodeIfPresent(Int64.self, forKey: .creationDate) {
            creationDate = .init(timeIntervalSince1970: .init(int64Value) / 1000)
        }
        timestamps = try container.decodeIfPresent(Timestamps.self, forKey: .timestamps)
        applicationID = try container.decodeIfPresent(Snowflake.self, forKey: .applicationID)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        emoji = try container.decodeIfPresent(Emoji.self, forKey: .emoji)
        party = try container.decodeIfPresent(Party.self, forKey: .party)
        assets = try container.decodeIfPresent(Assets.self, forKey: .assets)
        secrets = try container.decodeIfPresent(Secrets.self, forKey: .secrets)
        isInstance = try container.decodeIfPresent(Bool.self, forKey: .isInstance)
        flags = try container.decodeIfPresent(Flags.self, forKey: .flags)
        buttons = try container.decodeIfPresent([Button].self, forKey: .buttons)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(url, forKey: .url)
        if let timeInterval = creationDate?.timeIntervalSince1970 {
            try container.encode(Int64(timeInterval * 1000), forKey: .creationDate)
        }
        try container.encodeIfPresent(timestamps, forKey: .timestamps)
        try container.encodeIfPresent(applicationID, forKey: .applicationID)
        try container.encodeIfPresent(details, forKey: .details)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(party, forKey: .party)
        try container.encodeIfPresent(assets, forKey: .assets)
        try container.encodeIfPresent(secrets, forKey: .secrets)
        try container.encodeIfPresent(isInstance, forKey: .isInstance)
        try container.encodeIfPresent(flags, forKey: .flags)
        try container.encodeIfPresent(buttons, forKey: .buttons)
    }
}

extension Activity.Button: Codable {

    private enum CodingKeys: String, CodingKey {

        case label

        case url
    }
}

extension Activity.Emoji: Codable {

    private enum CodingKeys: String, CodingKey {

        case name

        case id

        case isAnimated = "animated"
    }
}

extension Activity.Secrets: Codable {

    private enum CodingKeys: String, CodingKey {

        case join

        case spectate

        case match
    }
}

extension Activity.Timestamps: Codable {

    private enum CodingKeys: String, CodingKey {

        case startDate = "start"

        case endDate = "end"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let int64Value = try container.decodeIfPresent(Int64.self, forKey: .startDate) {
            startDate = .init(timeIntervalSince1970: .init(int64Value) / 1000)
        }
        if let int64Value = try container.decodeIfPresent(Int64.self, forKey: .endDate) {
            endDate = .init(timeIntervalSince1970: .init(int64Value) / 1000)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let timeInterval = startDate?.timeIntervalSince1970 {
            try container.encode(Int64(timeInterval * 1000), forKey: .startDate)
        }
        if let timeInterval = endDate?.timeIntervalSince1970 {
            try container.encode(Int64(timeInterval * 1000), forKey: .endDate)
        }
    }
}
