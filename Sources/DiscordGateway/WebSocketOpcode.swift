//
//  WebSocketOpcode.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import NIOWebSocket

extension WebSocketOpcode {
    public static let discordDispatch = WebSocketOpcode(encodedWebSocketOpcode: 0)!
    public static let discordHeartbeat = WebSocketOpcode(encodedWebSocketOpcode: 1)!
    public static let discordIdentify = WebSocketOpcode(encodedWebSocketOpcode: 2)!
    public static let discordPresenceUpdate = WebSocketOpcode(encodedWebSocketOpcode: 3)!
    public static let discordVoiceStateUpdate = WebSocketOpcode(encodedWebSocketOpcode: 4)!
    public static let discordResume = WebSocketOpcode(encodedWebSocketOpcode: 6)!
    public static let discordReconnect = WebSocketOpcode(encodedWebSocketOpcode: 7)!
    public static let discordRequestGuildMembers = WebSocketOpcode(encodedWebSocketOpcode: 8)!
    public static let discordInvalidSession = WebSocketOpcode(encodedWebSocketOpcode: 9)!
    public static let discordHello = WebSocketOpcode(encodedWebSocketOpcode: 10)!
    public static let discordHeartbeatACK = WebSocketOpcode(encodedWebSocketOpcode: 11)!
}
