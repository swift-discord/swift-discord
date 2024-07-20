//
//  Application.Command+AttachmentOption.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension Application.Command {
    public struct AttachmentOption: RequirableOption {
        public let type = OptionType.attachment
        public var name: String
        public var nameLocalizations: Localizations?
        public var description: String
        public var descriptionLocalizations: Localizations?
        public var required: Bool?
    }
}

extension Application.Command.AttachmentOption: Codable {
    public enum CodingKeys: String, CodingKey {
        case type
        case name
        case nameLocalizations
        case description
        case descriptionLocalizations
        case required
    }
}
