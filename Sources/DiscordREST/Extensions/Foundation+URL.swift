//
//  Foundation+URL.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import DiscordCore

extension URL {
    public static func discordAPIBaseURL(for apiVersion: DiscordAPIVersion? = nil) -> URL {
        let discordAPIBaseURL = URL(string: "api/", relativeTo: .discord)!

        if let apiVersion {
            return discordAPIBaseURL
                .appendingPathComponent("v\(apiVersion.versionString)", isDirectory: true)
        } else {
            return discordAPIBaseURL
        }
    }

    public init?(discordAPIPath: String, apiVersion: DiscordAPIVersion? = nil) {
        self.init(
            string: discordAPIPath,
            relativeTo: .discordAPIBaseURL(for: apiVersion)
        )
    }
}
