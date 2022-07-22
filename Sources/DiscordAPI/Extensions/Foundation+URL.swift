//
//  Foundation+URL.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation

extension URL {
    public static let discordAPIBaseURL: URL = URL(string: "https://discord.com/api")!

    public init?(discordAPIPath: String) {
        self.init(
            string: discordAPIPath,
            relativeTo: Self.discordAPIBaseURL
                .deletingLastPathComponent()
                .appendingPathComponent(Self.discordAPIBaseURL.lastPathComponent, isDirectory: true)
        )
    }
}
