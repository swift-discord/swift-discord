//
//  VoiceReady.swift
//
//
//  Created by Jaehong Kang on 7/28/24.
//

public struct VoiceReady: Sendable, Decodable {
    public let ssrc: Int32
    public let ip: String
    public let modes: [String]
}
