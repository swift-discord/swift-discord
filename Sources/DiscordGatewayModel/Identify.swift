//
//  Identify.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

public struct Identify: Hashable, Sendable {

    public var token: String

    public var properties: ConnectionProperties

    public var supportsCompression: Bool?

    public var largeThreshold: Int?

    // TODO: shard
    //public var shard: Shard

    public var presence: PresenceUpdate?

    public var intents: Int

    public init(
        token: String,
        properties: ConnectionProperties,
        supportsCompression: Bool? = nil,
        largeThreshold: Int? = nil,
        presence: PresenceUpdate? = nil,
        intents: Int
    ) {
        self.token = token
        self.properties = properties
        self.supportsCompression = supportsCompression
        self.largeThreshold = largeThreshold
        self.presence = presence
        self.intents = intents
    }
}

extension Identify {

    public struct ConnectionProperties: Hashable, Sendable {

        public var os: String

        public var browser: String

        public var device: String

        public init(
            os: String,
            browser: String,
            device: String
        ) {
            self.os = os
            self.browser = browser
            self.device = device
        }
    }
}

extension Identify: Codable {

    private enum CodingKeys: String, CodingKey {

        case token

        case properties

        case supportsCompression = "compress"

        case largeThreshold

        // TODO: shard
        //case shard

        case presence

        case intents
    }
}

extension Identify.ConnectionProperties: Codable {

    private enum CodingKeys: String, CodingKey {

        case os

        case browser

        case device
    }
}
