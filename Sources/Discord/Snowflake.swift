//
//  Snowflake.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation

public struct Snowflake: RawRepresentable {
    public typealias RawValue = Int64

    public var rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

extension Snowflake: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            let string = try container.decode(String.self)

            guard let rawValue = Int64(string) else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "\(string) can not be parsed as Int64!"))
            }

            self.rawValue = rawValue
        } catch {
            let decodeError = error

            do {
                let int64 = try container.decode(Int64.self)

                self.rawValue = int64
            } catch {
                throw decodeError
            }
        }
    }
}
