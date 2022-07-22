//
//  OAuth2Credential.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation

public struct OAuth2Credential: Equatable, Hashable, Sendable {
    public typealias Scopes = [String]

    public let tokenType: String
    public let accessToken: String

    public let validityPeriod: DateInterval
    public let refreshToken: String?

    public let scopes: Scopes

    public init(
        tokenType: String,
        accessToken: String,
        validityPeriod: DateInterval,
        refreshToken: String? = nil,
        scopes: Scopes
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
        expiresIn: TimeInterval? = nil,
        expires: Date? = nil,
        refreshToken: String? = nil,
        scopes: Scopes
    ) {
        self.tokenType = tokenType
        self.accessToken = accessToken
        switch (expiresIn, expires) {
        case (.some(let expiresIn), .some(let expires)):
            self.validityPeriod = DateInterval(start: expires.addingTimeInterval(-expiresIn), end: expires)
        case (.none, .some(let expires)):
            self.validityPeriod = DateInterval(start: Date.distantPast, end: expires)
        case (.some(let expiresIn), .none):
            self.validityPeriod = DateInterval(start: Date(), duration: expiresIn)
        case (.none, .none):
            self.validityPeriod = DateInterval(start: .distantPast, end: .distantFuture)
        }
        self.refreshToken = refreshToken
        self.scopes = scopes
    }
}
