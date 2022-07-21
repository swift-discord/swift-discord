//
//  User.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation
import Discord

public struct User: Equatable, Hashable, Identifiable, Sendable, Codable {
    public enum PremiumType: Int, Equatable, Hashable, Sendable, Codable {
        case none = 0
        case nitroClassic = 1
        case nitro = 2
    }

    public let id: Snowflake

    public let username: String
    public let discriminator: String

    public let avatar: String?

    public let bot: Bool?
    public let system: Bool?
    public let mfaEnabled: Bool?
    public let banner: String?
    public let accentColor: Int?
    public let locale: String?
    public let verified: Bool?
    public let email: String?

    public let flags: Flags?
    public let premiumType: Unknown<PremiumType>?
    public let publicFlags: Flags?
}
