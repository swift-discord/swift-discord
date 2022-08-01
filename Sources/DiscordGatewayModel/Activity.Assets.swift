//
//  Activity.Assets.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

extension Activity {

    public struct Assets: Hashable, Sendable {

        public var largeImage: Image?

        public var largeText: String?

        public var smallImage: Image?

        public var smallText: String?

        public init(
            largeImage: Image? = nil,
            largeText: String? = nil,
            smallImage: Image? = nil,
            smallText: String? = nil
        ) {
            self.largeImage = largeImage
            self.largeText = largeText
            self.smallImage = smallImage
            self.smallText = smallText
        }
    }
}

extension Activity.Assets {

    public enum Image: Hashable, Sendable {

        case applicationAsset(id: Snowflake)

        case mediaProxyImage(id: String)
    }
}

extension Activity.Assets: Codable {

    private enum CodingKeys: String, CodingKey {

        case largeImage

        case largeText

        case smallImage

        case smallText
    }
}

extension Activity.Assets.Image {

    private static let mediaProxyPrefix: String = "mp:"
}

extension Activity.Assets.Image: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let snowflakeValue = try? container.decode(Snowflake.self) {
            self = .applicationAsset(id: snowflakeValue)
        }
        else {
            var stringValue = try container.decode(String.self)
            guard stringValue.hasPrefix(Self.mediaProxyPrefix)
            else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: container.codingPath,
                        debugDescription: "Expected to decode Snowflake or String that starts with '\(Self.mediaProxyPrefix)' but found other string instead."))
            }
            stringValue.removeFirst(Self.mediaProxyPrefix.count)
            self = .mediaProxyImage(id: stringValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .applicationAsset(id: let snowflakeValue):
            try container.encode(snowflakeValue)
        case .mediaProxyImage(id: let snowflakeValue):
            try container.encode("\(Self.mediaProxyPrefix)\(snowflakeValue)")
        }
    }
}
