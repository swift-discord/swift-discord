//
//  Application+_Command.swift
//
//
//  Created by Jaehong Kang on 7/15/24.
//

import Snowflake

extension Application {
    public protocol _Command: Sendable, Decodable {
        var name: String { get }
        var nameLocalizations: Localizations? { get }
        var type: CommandType { get }
        var applicationID: Snowflake { get }
        var guildID: Snowflake? { get }
        var description: String { get }
        var descriptionLocalizations: Localizations? { get }
        var defaultMemberPermissions: String? { get }
        @available(*, deprecated, renamed: "contexts")
        var dmPermission: Bool? { get }
        var defaultPermission: Bool? { get }
        var nsfw: Bool? { get }
    }

    public enum CommandType: Int, Sendable, Codable {
        case chatInput = 1
        case user
        case message
    }
}
