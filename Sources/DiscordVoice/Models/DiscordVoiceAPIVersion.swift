//
//  DiscordVoiceAPIVersion.swift
//
//
//  Created by Jaehong Kang on 6/28/24.
//

public struct DiscordVoiceAPIVersion: Equatable, Hashable, Sendable {
    public let versionString: String

    private init(versionString: String) {
        self.versionString = versionString
    }

    public static let v1: DiscordVoiceAPIVersion = .init(versionString: "3")

    public static let v2: DiscordVoiceAPIVersion = .init(versionString: "4")

    public static let v3: DiscordVoiceAPIVersion = .init(versionString: "5")

    public static let v4: DiscordVoiceAPIVersion = .init(versionString: "6")
}
