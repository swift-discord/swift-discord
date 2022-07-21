//
//  Sticker.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord

public struct Sticker: Equatable, Hashable, Identifiable, Sendable {
    public enum `Type`: Int, Equatable, Hashable, Sendable, Codable {
        case standard = 1
        case guild
    }

    public enum FormatType: Int, Equatable, Hashable, Sendable, Codable {
        case png = 1
        case apng
        case lottie
    }

    public let id: Snowflake

    public let packID: Snowflake?
    public let name: String
    public let description: String?
    public let tags: String

    public let type: Unknown<`Type`>
    public let formatType: Unknown<FormatType>
    public let isAvailable: Bool?

    public let guildID: Snowflake?
    public let user: User?

    public let sortValue: Int?
}

extension Sticker: Codable {
    enum CodingKeys: String, CodingKey {
        case id

        case packID = "packId"
        case name
        case description
        case tags

        case type
        case formatType
        case isAvailable = "available"

        case guildID = "guildId"
        case user

        case sortValue
    }
}
