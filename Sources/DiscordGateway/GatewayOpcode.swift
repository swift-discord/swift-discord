//
//  GatewayOpcode.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

public enum GatewayOpcode: Int, Codable {
    case dispatch = 0
    case heartbeat
    case identify
    case presenceUpdate
    case voiceStatusUpdate
    case resume = 6
    case reconnect
    case requestGuildMembers
    case invalidSession
    case hello
    case heartbeatACK
}
