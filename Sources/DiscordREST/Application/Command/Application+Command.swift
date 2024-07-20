//
//  Application Command.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

import Snowflake

extension Application {
    public struct Command: _Command {
        enum CodingKeys: CodingKey {
            case type
        }

        let base: any _Command

        public var name: String {
            base.name
        }

        public var nameLocalizations: Localizations? {
            base.nameLocalizations
        }

        public var type: Application.CommandType {
            base.type
        }

        public var applicationID: Snowflake {
            base.applicationID
        }

        public var guildID: Snowflake? {
            base.guildID
        }

        public var description: String {
            base.description
        }

        public var descriptionLocalizations: Localizations? {
            base.descriptionLocalizations
        }

        public var defaultMemberPermissions: String? {
            base.defaultMemberPermissions
        }

        @available(*, deprecated, renamed: "contexts")
        public var dmPermission: Bool? {
            base.dmPermission
        }

        public var defaultPermission: Bool? {
            base.defaultPermission
        }

        public var nsfw: Bool? {
            base.nsfw
        }

        public init(_ base: any _Command) {
            self.base = base
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(CommandType.self, forKey: .type)

            switch type {
            case .chatInput:
                self.base = try ChatInputCommand(from: decoder)
            case .user:
                self.base = try UserCommand(from: decoder)
            case .message:
                self.base = try MessageCommand(from: decoder)
            }
        }
    }
}
