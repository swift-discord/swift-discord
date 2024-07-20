//
//  Application.Command+NumberOption.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension Application.Command {
    public struct NumberOption: RequirableOption, ChoicableOption, ValueTypeOption, AutocompletableOption {
        public typealias Value = Double

        public let type = OptionType.number
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var required: Bool?
        public var choices: [Choice<Value>]?
        public var minValue: Value?
        public var maxValue: Value?
        public var autocomplete: Bool?
    }
}

extension Application.Command.NumberOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case required
        case choices
        case minValue
        case maxValue
        case autocomplete
    }
}
