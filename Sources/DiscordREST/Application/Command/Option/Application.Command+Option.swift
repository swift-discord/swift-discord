//
//  Application.Command+AnyOption.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

extension Application.Command {
    public struct Option: _Option {
        public enum CodingKeys: CodingKey {
            case type
        }

        public let base: any _Option

        public var type: Application.Command.OptionType {
            base.type
        }

        public var name: String {
            base.name
        }

        public var nameLocalizations: Localizations? {
            base.nameLocalizations
        }

        public var description: String {
            base.description
        }

        public var descriptionLocalizations: Localizations? {
            base.descriptionLocalizations
        }

        public init(_ base: any _Option) {
            self.base = base
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(OptionType.self, forKey: .type)

            switch type {
            case .subCommand:
                self.base = try SubCommandOption(from: decoder)
            case .subCommandGroup:
                self.base = try SubCommandGroupOption(from: decoder)
            case .string:
                self.base = try StringOption(from: decoder)
            case .integer:
                self.base = try IntegerOption(from: decoder)
            case .boolean:
                self.base = try BooleanOption(from: decoder)
            case .user:
                self.base = try UserOption(from: decoder)
            case .channel:
                self.base = try ChannelOption(from: decoder)
            case .role:
                self.base = try RoleOption(from: decoder)
            case .mentionable:
                self.base = try MentionableOption(from: decoder)
            case .number:
                self.base = try NumberOption(from: decoder)
            case .attachment:
                self.base = try AttachmentOption(from: decoder)
            }
        }

        public func encode(to encoder: any Encoder) throws {
            try base.encode(to: encoder)
        }
    }
}
