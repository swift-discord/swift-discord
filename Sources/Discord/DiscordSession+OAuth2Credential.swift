//
//  DiscordSession+OAuth2Credential.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import OrderedCollections

extension DiscordSession {
    public struct OAuth2Credential: Equatable, Hashable {
        public let tokenType: String
        public let accessToken: String

        public let validityPeriod: DateInterval
        public let refreshToken: String?

        public let scopes: OrderedSet<String>

        public init(tokenType: String, accessToken: String, validityPeriod: DateInterval, refreshToken: String? = nil, scopes: OrderedSet<String>) {
            self.tokenType = tokenType
            self.accessToken = accessToken
            self.validityPeriod = validityPeriod
            self.refreshToken = refreshToken
            self.scopes = scopes
        }
    }
}

extension DiscordSession.OAuth2Credential {
    public init(tokenType: String, accessToken: String, expiresIn: TimeInterval, expires: Date? = nil, refreshToken: String? = nil, scopes: OrderedSet<String>) {
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

extension DiscordSession.OAuth2Credential: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken
        case tokenType
        case expiresIn
        case expires
        case refreshToken
        case scope
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let tokenType = try container.decode(String.self, forKey: .tokenType)
        let accessToken = try container.decode(String.self, forKey: .accessToken)

        let expiresIn = try container.decode(TimeInterval.self, forKey: .expiresIn)
        let expires = try container.decodeIfPresent(Date.self, forKey: .expires)

        let refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)

        let scopes = OrderedSet(try container.decode(String.self, forKey: .scope).components(separatedBy: " "))

        self.init(
            tokenType: tokenType,
            accessToken: accessToken,
            expiresIn: expiresIn,
            expires: expires,
            refreshToken: refreshToken,
            scopes: scopes
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(accessToken, forKey: .accessToken)

        try container.encode(validityPeriod.duration, forKey: .expiresIn)
        try container.encode(validityPeriod.end, forKey: .expires)
        try container.encode(refreshToken, forKey: .refreshToken)

        try container.encode(scopes.joined(separator: " "), forKey: .scope)
    }
}
