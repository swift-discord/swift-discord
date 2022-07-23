//
//  WebSocketHandler.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

import NIOCore
import NIOWebSocket

class WebSocketHandler {
    weak var webSocketSession: WebSocketSession?

    init(webSocketSession: WebSocketSession? = nil) {
        self.webSocketSession = webSocketSession
    }
}

extension WebSocketHandler: ChannelInboundHandler {
    typealias InboundIn = WebSocketFrame
    typealias OutboundOut = WebSocketFrame

    // This is being hit, channel active won't be called as it is already added.
    func handlerAdded(context: ChannelHandlerContext) {
        guard webSocketSession != nil else {
            context.close(promise: nil)
            return
        }

        print("WebSocket handler added.")
    }

    func handlerRemoved(context: ChannelHandlerContext) {
        guard webSocketSession != nil else {
            context.close(promise: nil)
            return
        }

        print("WebSocket handler removed.")
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        guard let webSocketSession = webSocketSession else {
            context.close(promise: nil)
            return
        }

        let frame = self.unwrapInboundIn(data)
        webSocketSession.receivedFrame(frame, context: context)
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        guard webSocketSession != nil else {
            context.close(promise: nil)
            return
        }

        debugPrint(error)
    }
}
