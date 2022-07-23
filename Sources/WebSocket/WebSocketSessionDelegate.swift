//
//  WebSocketSessionDelegate.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

public protocol WebSocketSessionDelegate: AnyObject {
    typealias Context = WebSocketSessionDelegateContext

    func didReceiveMessage(_ message: WebSocketSession.Message, context: Context)
}
