//
//  Activity.Party.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

extension Activity {

    public struct Party: Hashable, Sendable {

        public var id: String?

        public var size: Size

        public init(
            id: String? = nil,
            size: Size
        ) {
            self.id = id
            self.size = size
        }
    }
}

extension Activity.Party {

    public struct Size: Hashable, Sendable {

        public var current: Int

        public var max: Int

        public init(
            current: Int,
            max: Int
        ) {
            self.current = current
            self.max = max
        }
    }
}

extension Activity.Party: Codable {

    private enum CodingKeys: String, CodingKey {

        case id

        case size
    }
}

extension Activity.Party.Size: Codable {

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        current = try container.decode(Int.self)
        max = try container.decode(Int.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(current)
        try container.encode(max)
    }
}
