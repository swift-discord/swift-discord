//
//  JSONNumber.swift
//  
//
//  Created by Jaehong Kang on 2022/07/24.
//

import Foundation

public enum JSONNumber: Sendable, Equatable, Hashable {
    case int(Int64)
    case float(Float64)
}

extension JSONNumber {
    public var int: Int64? {
        guard case let .int(int) = self else {
            return nil
        }

        return int
    }

    public var float: Float64? {
        guard case let .float(float) = self else {
            return nil
        }

        return float
    }

    public var decimal: Decimal {
        switch self {
        case .int(let int):
            return Decimal(int)
        case .float(let float):
            return Decimal(float)
        }
    }
}

extension JSONNumber: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.decimal < rhs.decimal
    }
}

extension JSONNumber: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int64

    public init(integerLiteral value: Int64) {
        self = .int(value)
    }
}

extension JSONNumber: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Float64

    public init(floatLiteral value: Float64) {
        self = .float(value)
    }
}

extension JSONNumber: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int64.self) {
            self = .int(int)
        } else {
            self = .float(try container.decode(Double.self))
        }
    }
}

extension JSONNumber: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let int):
            try container.encode(int)
        case .float(let float):
            try container.encode(float)
        }
    }
}
