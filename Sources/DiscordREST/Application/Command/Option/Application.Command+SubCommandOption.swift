//
//  Application.Command+SubCommandOption.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

extension Application.Command {
    public struct SubCommandOption: SubOption {
        public let type = OptionType.subCommand
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var options: [any _Option]?

        public init(
            name: String,
            nameLocalizations: Localizations? = nil,
            description: String,
            descriptionLocalizations: Localizations? = nil,
            options: [any _Option]? = nil
        ) {
            self.name = name
            self.nameLocalizations = nameLocalizations
            self.description = description
            self.descriptionLocalizations = descriptionLocalizations
            self.options = options
        }
    }
}

extension Application.Command.SubCommandOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case options
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.nameLocalizations = try container.decodeIfPresent(Localizations.self, forKey: .nameLocalizations)
        self.description = try container.decode(String.self, forKey: .description)
        self.descriptionLocalizations = try container.decodeIfPresent(Localizations.self, forKey: .descriptionLocalizations)
        self.options = try container.decode([Application.Command.Option].self, forKey: .options).map(\.base)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(nameLocalizations, forKey: .nameLocalizations)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(descriptionLocalizations, forKey: .descriptionLocalizations)
        try container.encodeIfPresent(options?.map(Application.Command.Option.init), forKey: .options)
    }
}
