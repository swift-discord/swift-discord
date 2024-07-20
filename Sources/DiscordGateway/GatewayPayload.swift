//
//  GatewayPayload.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import DiscordCore
import Foundation

public struct GatewayPayload<Data: Codable>: Codable {
    public let opcode: GatewayOpcode
    public let data: Data?
    public let sequence: Int?
    public let type: String?
}

extension GatewayPayload {
    enum CodingKeys: String, CodingKey {
        case opcode = "op"
        case data = "d"
        case sequence = "s"
        case type = "t"
    }
}

public typealias GatewayDynamicPayload = GatewayPayload<JSONValue>

extension GatewayPayload {
    public init<T: Codable>(_ gatewayPayload: GatewayPayload<T>) throws {
        self = try JSONDecoder.discord.decode(Self.self, from: JSONEncoder.discord.encode(gatewayPayload))
    }
}
