//
//  RateLimit.swift
//  
//
//  Created by Mina Her on 2022/07/28.
//

import Foundation
#if canImport(FoundationNetworking)
import class FoundationNetworking.HTTPURLResponse
#endif

public struct RateLimit: Sendable {

    public var limit: Int?

    public var remaining: Int?

    public var reset: Date?

    public var resetAfterSeconds: TimeInterval?

    public var bucket: String?

    public var isGlobal: Bool?

    public var scope: Scope?

    public init() {
    }
}

extension RateLimit {

    public enum Scope: String, Hashable, Sendable {

        case user

        case global

        case shared
    }
}

extension RateLimit {

    internal init(httpURLResponse: HTTPURLResponse) {
        let limit = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Limit")
        let remaining = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Remaining")
        let reset = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Reset")
        let resetAfter = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Reset-After")
        let bucket = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Bucket")
        let global = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Global")
        let scope = httpURLResponse.value(forHTTPHeaderField: "X-RateLimit-Scope")
        if let limit = limit {
            self.limit = .init(limit)
        }
        if let remaining = remaining {
            self.remaining = .init(remaining)
        }
        if let reset = reset {
            if let reset = TimeInterval(reset) {
                self.reset = .init(timeIntervalSince1970: reset)
            }
        }
        if let resetAfter = resetAfter {
            self.resetAfterSeconds = .init(resetAfter)
        }
        self.bucket = bucket
        if let global = global {
            self.isGlobal = .init(global)
        }
        if let scope = scope {
            self.scope = .init(rawValue: scope)
        }
    }
}
