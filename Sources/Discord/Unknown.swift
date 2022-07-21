//
//  Unknown.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation

public enum Unknown<T> where T: RawRepresentable {
    case value(T)
    case rawValue(T.RawValue)
}

extension Unknown: RawRepresentable {
    public var rawValue: T.RawValue {
        switch self {
        case .value(let value):
            return value.rawValue
        case .rawValue(let rawValue):
            return rawValue
        }
    }

    public init(rawValue: T.RawValue) {
        if let value = T(rawValue: rawValue) {
            self = .value(value)
        } else {
            self = .rawValue(rawValue)
        }
    }
}

extension Unknown: Equatable where T.RawValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension Unknown: Hashable where T.RawValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Unknown: Comparable where T.RawValue: Comparable {
    public static func < (lhs: Unknown<T>, rhs: Unknown<T>) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Unknown: Sendable where T: Sendable, T.RawValue: Sendable { }

extension Unknown: Codable where T: Codable, T.RawValue: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let rawValue = try container.decode(T.RawValue.self)

        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var encoder = encoder.singleValueContainer()

        try encoder.encode(rawValue)
    }
}
