//
//  VoiceSession+Error.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

extension VoiceSession {
    enum Error: Swift.Error {
        case unknown
        case guildVoiceStatesIntentRequired
        case invalidVoiceGatewayURL
        case notAuthenticated
    }
}
