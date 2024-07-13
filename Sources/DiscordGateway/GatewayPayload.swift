//
//  GatewayPayload.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import DiscordCore

public protocol GatewayPayloadable<Data>  {
    associatedtype Data

    var opcode: GatewayOpcode { get }
    var data: Data? { get }
    var sequence: Int? { get }
    var type: String? { get }
}

public struct GatewayPayload<Data>: GatewayPayloadable {
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

extension GatewayPayload: Decodable where Data: Decodable {

}

extension GatewayPayload: Encodable where Data: Encodable {

}

public typealias GatewayDynamicPayload = GatewayPayload<JSONValue>
