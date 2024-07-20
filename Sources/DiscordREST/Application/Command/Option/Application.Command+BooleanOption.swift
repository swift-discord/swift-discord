//
//  Application.Command+BooleanOption.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

extension Application.Command {
    public struct BooleanOption: RequirableOption {
        public let type = OptionType.boolean
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var required: Bool?
    }
}

extension Application.Command.BooleanOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case required
    }
}
