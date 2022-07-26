//
//  WebSocketSession+CloseCode.swift
//  
//
//  Created by Jaehong Kang on 2022/07/25.
//

import NIOWebSocket

extension WebSocketSession {
    public enum CloseCode: UInt16, Equatable, Hashable, Sendable {
        case normalClosure = 1000

        case goingAway = 1001

        case protocolError = 1002

        case unsupportedData = 1003

        case noStatusReceived = 1005

        case abnormalClosure = 1006

        case invalidFramePayloadData = 1007

        case policyViolation = 1008

        case messageTooBig = 1009

        case mandatoryExtensionMissing = 1010

        case internalServerError = 1011

        case tlsHandshakeFailure = 1015
    }
}

extension WebSocketSession.CloseCode {
    var webSocketErrorCode: WebSocketErrorCode {
        .init(codeNumber: Int(self.rawValue))
    }
}
