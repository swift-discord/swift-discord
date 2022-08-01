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
}
