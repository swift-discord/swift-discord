//
//  VoiceSession+State.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

extension VoiceSession {
    public enum State {
        case disconnected
        case connecting
        case connected
        case ready
    }
}
