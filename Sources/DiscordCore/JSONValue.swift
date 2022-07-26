//
//  JSONValue.swift
//  
//
//  Created by Jaehong Kang on 2022/07/24.
//

import Foundation

public enum JSONValue: Sendable, Equatable, Hashable {
    public typealias Object = [String: JSONValue?]
    public typealias Array = [JSONValue?]
    public typealias Number = JSONNumber

    case object(Object)
    case array(Array)
    case string(String)
    case number(Number)
    case bool(Bool)
}

extension JSONValue {
    public var object: Object? {
        guard case let .object(object) = self else {
            return nil
        }

        return object
    }

    public var array: Array? {
        guard case let .array(array) = self else {
            return nil
        }

        return array
    }

    public var string: String? {
        guard case let .string(string) = self else {
            return nil
        }

        return string
    }

    public var number: Number? {
        guard case let .number(number) = self else {
            return nil
        }

        return number
    }

    public var bool: Bool? {
        guard case let .bool(bool) = self else {
            return nil
        }

        return bool
    }
}

extension JSONValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Array.Element

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self = .array(elements)
    }
}

extension JSONValue: ExpressibleByDictionaryLiteral {
    public typealias Key = Object.Key
    public typealias Value = Object.Value

    public init(dictionaryLiteral elements: (Key, Value)...) {
        self = .object(.init(uniqueKeysWithValues: elements))
    }
}

extension JSONValue: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Number.IntegerLiteralType

    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(.init(integerLiteral: value))
    }
}

extension JSONValue: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Number.FloatLiteralType

    public init(floatLiteral value: FloatLiteralType) {
        self = .number(.init(floatLiteral: value))
    }
}

extension JSONValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode(Object.self) {
            self = .object(object)
        } else if let array = try? container.decode(Array.self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Number.self) {
            self = .number(number)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown type.")
        }
    }
}

extension JSONValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .object(let object):
            try container.encode(object)
        case .array(let array):
            try container.encode(array)
        case .string(let string):
            try container.encode(string)
        case .number(let number):
            try container.encode(number)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
}
