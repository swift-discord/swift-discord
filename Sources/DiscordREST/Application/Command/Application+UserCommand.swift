//
//  Application+UserCommand.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

import Snowflake

extension Application {
    public struct UserCommand: _Command {
        public let name: String
        public let nameLocalizations: Localizations?
        public var type: CommandType { .user }
        public let applicationID: Snowflake
        public let guildID: Snowflake?
        public let description: String
        public let descriptionLocalizations: Localizations?
        public let defaultMemberPermissions: String?
        @available(*, deprecated, renamed: "contexts")
        public let dmPermission: Bool?
        public let defaultPermission: Bool?
        public let nsfw: Bool?
    }
}
