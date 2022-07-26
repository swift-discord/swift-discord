//
//  WebSocketSessionDelegateContext.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

import NIOCore
import NIOWebSocket

public struct WebSocketSessionDelegateContext {
    public let session: WebSocketSession
    let channelHandlerContext: ChannelHandlerContext?
    let frame: WebSocketFrame?
}
