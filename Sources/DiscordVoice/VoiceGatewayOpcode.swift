//
//  VoiceGatewayOpcode.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

public enum VoiceGatewayOpcode: Int, Equatable, Hashable, Codable, Sendable {
    case identify = 0
    case selectProtocol
    case ready
    case heartbeat
    case sessionDescription
    case speaking
    case heartbeatACK
    case resume
    case hello
    case resumed
    case clientDisconnect = 13
}
