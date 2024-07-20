//
//  Application+ChatInputCommand.swift
//
//
//  Created by Jaehong Kang on 7/15/24.
//

import Snowflake

extension Application {
    public struct ChatInputCommand: _Command {
        public let name: String
        public let nameLocalizations: Localizations?
        public var type: CommandType { .chatInput }
        public let applicationID: Snowflake
        public let guildID: Snowflake?
        public let description: String
        public let descriptionLocalizations: Localizations?
        public let options: [any Command._Option]
        public let defaultMemberPermissions: String?
        @available(*, deprecated, renamed: "contexts")
        public let dmPermission: Bool?
        public let defaultPermission: Bool?
        public let nsfw: Bool?
    }
}

extension Application.ChatInputCommand: Decodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case nameLocalizations
        case applicationID
        case guildID
        case description
        case descriptionLocalizations
        case options
        case defaultMemberPermissions
        case dmPermission
        case defaultPermission
        case nsfw
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.nameLocalizations = try container.decodeIfPresent(Localizations.self, forKey: .nameLocalizations)
        self.applicationID = try container.decode(Snowflake.self, forKey: .applicationID)
        self.guildID = try container.decodeIfPresent(Snowflake.self, forKey: .guildID)
        self.description = try container.decode(String.self, forKey: .description)
        self.descriptionLocalizations = try container.decodeIfPresent(Localizations.self, forKey: .description)
        self.options = try container.decode([Application.Command.Option].self, forKey: .options).map(\.base)
        self.defaultMemberPermissions = try container.decodeIfPresent(String.self, forKey: .defaultMemberPermissions)
        self.dmPermission = try container.decodeIfPresent(Bool.self, forKey: .dmPermission)
        self.defaultPermission = try container.decode(Bool.self, forKey: .defaultPermission)
        self.nsfw = try container.decodeIfPresent(Bool.self, forKey: .nsfw)
    }
}
