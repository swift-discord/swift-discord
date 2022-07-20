//
//  OAuth2Credential.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import OrderedCollections

public struct OAuth2Credential: Equatable, Hashable {
    public let tokenType: String
    public let accessToken: String

    public let validityPeriod: DateInterval
    public let refreshToken: String?

    public let scopes: OrderedSet<String>

    public init(
        tokenType: String,
        accessToken: String,
        validityPeriod: DateInterval,
        refreshToken: String? = nil,
        scopes: OrderedSet<String>
    ) {
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.validityPeriod = validityPeriod
        self.refreshToken = refreshToken
        self.scopes = scopes
    }
}

extension OAuth2Credential {
    public init(
        tokenType: String,
        accessToken: String,
        expiresIn: TimeInterval,
        expires: Date? = nil,
        refreshToken: String? = nil,
        scopes: OrderedSet<String>
    ) {
        self.tokenType = tokenType
        self.accessToken = accessToken
        if let expires = expires {
            self.validityPeriod = DateInterval(
                start: expires.addingTimeInterval(-expiresIn),
                end: expires
            )
        } else {
            self.validityPeriod = DateInterval(start: Date(), duration: expiresIn)
        }
        self.refreshToken = refreshToken
        self.scopes = scopes
    }
}
