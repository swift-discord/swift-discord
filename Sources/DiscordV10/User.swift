//
//  User.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation
import Discord

public struct User {
    public enum PremiumType: Int {
        case none = 0
        case nitroClassic = 1
        case nitro = 2
    }

    let id: Snowflake

    let username: String
    let discriminator: String

    let avatar: String?

    let bot: Bool?
    let system: Bool?
    let mfaEnabled: Bool?
    let banner: String?
    let accentColor: Int?
    let locale: String?
    let verified: Bool?
    let email: String?

    let flags: Flags?
    let premiumType: PremiumType?
    let publicFlags: Flags?
}
