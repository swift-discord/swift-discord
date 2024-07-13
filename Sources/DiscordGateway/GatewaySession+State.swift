//
//  GatewaySession+State.swift
//
//
//  Created by Jaehong Kang on 7/13/24.
//

extension GatewaySession {
    public enum State {
        case disconnected
        case connecting
        case connected
        case ready
    }
}
