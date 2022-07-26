//
//  Foundation+URL.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import DiscordCore

extension URL {
    public static let discordAPIBaseURL: URL = URL(string: "api", relativeTo: Self.discordURL)!

    public init?(discordAPIPath: String) {
        self.init(
            string: discordAPIPath,
            relativeTo: Self.discordAPIBaseURL
                .deletingLastPathComponent()
                .appendingPathComponent(Self.discordAPIBaseURL.lastPathComponent, isDirectory: true)
        )
    }

    public init?(discordAPIPath: String, apiVersion: DiscordAPIVersion) {
        self.init(
            string: discordAPIPath,
            relativeTo: Self.discordAPIBaseURL
                .appendingPathComponent("v\(apiVersion.versionString)", isDirectory: true)
        )
    }
}
