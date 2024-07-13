//
//  RateLimitError.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation

public struct RateLimitError: Hashable, Sendable {

    public var message: String

    public var retryAfterSeconds: TimeInterval

    public var isGlobal: Bool
}

extension RateLimitError: Codable {

    private enum CodingKeys: String, CodingKey {

        case message

        case retryAfterSeconds = "retryAfter"

        case isGlobal = "global"
    }
}

extension RateLimitError: LocalizedError {

    public var errorDescription: String? {
        message
    }

    public var recoverySuggestion: String? {
        "Retry after \(Int(ceil(retryAfterSeconds))) second(s)"
    }
}
