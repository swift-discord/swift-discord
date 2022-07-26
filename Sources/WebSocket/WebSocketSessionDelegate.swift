//
//  WebSocketSessionDelegate.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

import Foundation

public protocol WebSocketSessionDelegate: AnyObject {
    typealias Context = WebSocketSessionDelegateContext

    func didOpen(context: Context)
    func didReceiveMessage(_ message: WebSocketSession.Message, context: Context)
    func didReceiveClose(code: WebSocketSession.CloseCode?, reason: Data?, context: Context)
    func didClose(context: Context)
}

extension WebSocketSessionDelegate {
    public func didOpen(context: Context) { }
    public func didReceiveMessage(_ message: WebSocketSession.Message, context: Context) { }
    public func didReceiveClose(code: WebSocketSession.CloseCode?, reason: Data?, context: Context) { }
    public func didClose(context: Context) { }
}
