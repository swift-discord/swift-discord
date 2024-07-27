//
//  VoiceGatewayPayload.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

import DiscordCore
import DiscordGateway
import Foundation

public struct VoiceGatewayPayload<Data>: GatewayPayloadable {
    public let opcode: VoiceGatewayOpcode
    public let data: Data
}

extension VoiceGatewayPayload {
    enum CodingKeys: String, CodingKey {
        case opcode = "op"
        case data = "d"
    }
}

extension VoiceGatewayPayload: Equatable where Data: Equatable { }
extension VoiceGatewayPayload: Hashable where Data: Hashable { }
extension VoiceGatewayPayload: Sendable where Data: Sendable { }
extension VoiceGatewayPayload: Encodable where Data: Encodable { }
extension VoiceGatewayPayload: Decodable where Data: Decodable { }

public typealias VoiceGatewayDynamicPayload = VoiceGatewayPayload<JSONValue?>

extension VoiceGatewayPayload where Data: Decodable {
    public init<T: Encodable>(_ payload: VoiceGatewayPayload<T>) throws {
        self = try JSONDecoder.discord.decode(Self.self, from: JSONEncoder.discord.encode(payload))
    }
}
