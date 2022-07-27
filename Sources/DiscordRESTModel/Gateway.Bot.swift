//
//  Gateway.Bot.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation

extension Gateway {

    public struct Bot: Hashable, Sendable {

        public var url: URL

        public var shards: Int

        public var sessionStartLimit: SessionStartLimit
    }
}

extension Gateway.Bot {

    public struct SessionStartLimit: Hashable, Sendable {

        public var total: Int

        public var remaining: Int

        public var resetAfterSeconds: TimeInterval

        public var maxConcurrency: Int
    }
}

extension Gateway.Bot: Codable {

    private enum CodingKeys: String, CodingKey {

        case url

        case shards

        case sessionStartLimit
    }
}

extension Gateway.Bot.SessionStartLimit: Codable {

    private enum CodingKeys: String, CodingKey {

        case total

        case remaining

        case resetAfterSeconds = "resetAfter"

        case maxConcurrency
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        remaining = try container.decode(Int.self, forKey: .remaining)
        resetAfterSeconds = .init(try container.decode(Int.self, forKey: .resetAfterSeconds)) / 1000
        maxConcurrency = try container.decode(Int.self, forKey: .maxConcurrency)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(remaining, forKey: .remaining)
        try container.encode(Int(resetAfterSeconds * 1000), forKey: .resetAfterSeconds)
        try container.encode(maxConcurrency, forKey: .maxConcurrency)
    }
}
