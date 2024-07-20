//
//  Application.Command+UserOption.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

extension Application.Command {
    public struct UserOption: RequirableOption {
        public let type = OptionType.user
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var required: Bool?

        public init(
            name: String,
            nameLocalizations: Localizations? = nil,
            description: String,
            descriptionLocalizations: Localizations? = nil,
            required: Bool? = nil
        ) {
            self.name = name
            self.nameLocalizations = nameLocalizations
            self.description = description
            self.descriptionLocalizations = descriptionLocalizations
            self.required = required
        }
    }
}

extension Application.Command.UserOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case required
    }
}
