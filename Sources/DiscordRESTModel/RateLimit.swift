//
//  RateLimit.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation

public struct RateLimit: Hashable, Sendable {

    public var message: String

    public var retryAfterSeconds: TimeInterval

    public var isGlobal: Bool
}

extension RateLimit: Codable {

    private enum CodingKeys: String, CodingKey {

        case message

        case retryAfterSeconds = "retryAfter"

        case isGlobal = "global"
    }
}

extension RateLimit: LocalizedError {

    public var errorDescription: String? {
        message
    }

    public var recoverySuggestion: String? {
        "Retry after \(Int(ceil(retryAfterSeconds))) second(s)"
    }
}
