//
//  GatewayPayload.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation

public struct GatewayPayload {
    public enum Data {
        public typealias Dictionary = [String: Data]
        public typealias Array = [Data]

        case int(Int)
        case string(String)
        case dictionary(Dictionary)
        case array(Array)
    }

    public let opcode: UInt8
    public let data: Data?
    public let sequence: Int?
    public let type: String?
}

extension GatewayPayload: Codable {
    enum CodingKeys: String, CodingKey {
        case opcode = "op"
        case data = "d"
        case sequence = "s"
        case type = "t"
    }
}

extension GatewayPayload.Data {
    public var intValue: Int? {
        guard case let .int(int) = self else {
            return nil
        }

        return int
    }

    public var stringValue: String? {
        guard case let .string(string) = self else {
            return nil
        }

        return string
    }

    public var dictionaryValue: Dictionary? {
        guard case let .dictionary(dictionary) = self else {
            return nil
        }

        return dictionary
    }

    public var arrayValue: Array? {
        guard case let .array(array) = self else {
            return nil
        }

        return array
    }
}

extension GatewayPayload.Data: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let dictionary = try? container.decode(Dictionary.self) {
            self = .dictionary(dictionary)
        } else if let array = try? container.decode(Array.self) {
            self = .array(array)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown type.")
        }
    }
}

extension GatewayPayload.Data: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        case .dictionary(let dictionary):
            try container.encode(dictionary)
        case .array(let array):
            try container.encode(array)
        }
    }
}
