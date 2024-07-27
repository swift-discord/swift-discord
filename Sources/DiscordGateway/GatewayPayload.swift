//
//  GatewayPayload.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import DiscordCore
import Foundation

public struct GatewayPayload<Data>: GatewayPayloadable {
    public let opcode: GatewayOpcode
    public let data: Data
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

extension GatewayPayload: Equatable where Data: Equatable { }
extension GatewayPayload: Hashable where Data: Hashable { }
extension GatewayPayload: Sendable where Data: Sendable { }
extension GatewayPayload: Encodable where Data: Encodable { }
extension GatewayPayload: Decodable where Data: Decodable { }

public typealias GatewayDynamicPayload = GatewayPayload<JSONValue?>

extension GatewayPayload where Data: Decodable {
    public init<T: Encodable>(_ gatewayPayload: GatewayPayload<T>) throws {
        self = try JSONDecoder.discord.decode(Self.self, from: JSONEncoder.discord.encode(gatewayPayload))
    }
}
