//
//  Hello.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

import struct Foundation.TimeInterval

public struct Hello: Hashable, Sendable {

    public var heartbeatInterval: TimeInterval
}

extension Hello: Codable {

    private enum CodingKeys: String, CodingKey {

        case heartbeatInterval
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heartbeatInterval = .init(try container.decode(Int.self, forKey: .heartbeatInterval)) / 1000
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Int(heartbeatInterval * 1000), forKey: .heartbeatInterval)
    }
}
