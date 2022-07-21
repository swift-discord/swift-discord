//
//  OptionSet.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation

extension OptionSet where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        self.init(rawValue: try container.decode(RawValue.self))
    }
}

extension OptionSet where RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(rawValue)
    }
}
