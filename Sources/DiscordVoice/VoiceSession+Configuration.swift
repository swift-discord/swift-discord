//
//  VoiceSession+Configuration.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension VoiceSession {
    public struct Configuration: Sendable {
        public var voiceAPIVersion: DiscordVoiceAPIVersion?

        public init(
            voiceAPIVersion: DiscordVoiceAPIVersion? = nil
        ) {
            self.voiceAPIVersion = voiceAPIVersion
        }
    }
}
