//
//  WebSocketSession+Message.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

import Foundation
import NIOCore
import NIOFoundationCompat

extension WebSocketSession {
    public enum Message {
        case data(Data)
        case string(String)
    }
}

extension ByteBufferAllocator {
    @inlinable
    func buffer(webSocketSessionMessage message: WebSocketSession.Message) -> ByteBuffer {
        switch message {
        case .data(let data):
            return buffer(data: data)
        case .string(let string):
            return buffer(string: string)
        }
    }
}
