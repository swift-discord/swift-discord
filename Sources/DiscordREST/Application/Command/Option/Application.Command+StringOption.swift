//
//  Application.Command+StringOption.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

extension Application.Command {
    public struct StringOption: RequirableOption, ChoicableOption, AutocompletableOption {
        public typealias Value = String

        public let type = OptionType.string
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var required: Bool?
        public var choices: [Choice<Value>]?
        public var minLength: Int?
        public var maxLength: Int?
        public var autocomplete: Bool?

        public init(
            name: String,
            nameLocalizations: Localizations? = nil,
            description: String,
            descriptionLocalizations: Localizations? = nil,
            required: Bool? = nil,
            choices: [Choice<Value>]? = nil,
            minLength: Int? = nil,
            maxLength: Int? = nil,
            autocomplete: Bool? = nil
        ) {
            self.name = name
            self.nameLocalizations = nameLocalizations
            self.description = description
            self.descriptionLocalizations = descriptionLocalizations
            self.required = required
            self.choices = choices
            self.minLength = minLength
            self.maxLength = maxLength
            self.autocomplete = autocomplete
        }
    }
}

extension Application.Command.StringOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case required
        case choices
        case minLength
        case maxLength
        case autocomplete
    }
}
