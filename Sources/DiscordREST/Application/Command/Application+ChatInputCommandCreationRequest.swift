//
//  Application+ChatInputCommandCreationRequest.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension Application {
    public struct ChatInputCommandCreationRequest: CommandCreationRequest {
        public var name: String
        public var nameLocalizations: Localizations?
        public var type: CommandType { .chatInput }
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var options: [any Command._Option]
        public var defaultMemberPermissions: String?
        @available(*, deprecated, renamed: "contexts")
        public var dmPermission: Bool?
        public var defaultPermission: Bool?
        public var nsfw: Bool?

        public init(
            name: String,
            nameLocalizations: Localizations? = nil,
            description: String,
            descriptionLocalizations: Localizations? = nil,
            options: [any Command._Option],
            defaultMemberPermissions: String? = nil,
            dmPermission: Bool? = nil,
            defaultPermission: Bool? = nil,
            nsfw: Bool? = nil
        ) {
            self.name = name
            self.nameLocalizations = nameLocalizations
            self.description = description
            self.descriptionLocalizations = descriptionLocalizations
            self.options = options
            self.defaultMemberPermissions = defaultMemberPermissions
            self.dmPermission = dmPermission
            self.defaultPermission = defaultPermission
            self.nsfw = nsfw
        }
    }
}

extension Application.ChatInputCommandCreationRequest: Encodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case nameLocalizations
        case type
        case description
        case descriptionLocalizations
        case options
        case defaultMemberPermissions
        case dmPermission
        case defaultPermission
        case nsfw
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(nameLocalizations, forKey: .nameLocalizations)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(descriptionLocalizations, forKey: .descriptionLocalizations)
        try container.encode(options.map(Application.Command.Option.init), forKey: .options)
        try container.encodeIfPresent(defaultMemberPermissions, forKey: .defaultMemberPermissions)
        try container.encodeIfPresent(dmPermission, forKey: .dmPermission)
        try container.encodeIfPresent(defaultPermission, forKey: .defaultPermission)
        try container.encodeIfPresent(nsfw, forKey: .nsfw)
    }
}
