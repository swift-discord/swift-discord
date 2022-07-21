//
//  Guild+API.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Discord

extension Guild {
    public static func myGuilds(session: Session) async throws -> [Guild] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/users/@me/guilds")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let guilds = try JSONDecoder.discord.decode([Guild].self, from: data)

        return guilds
    }
}

extension Guild {
    public init(guildID: Snowflake, session: Session) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/guilds/\(guildID.rawValue)")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(Guild.self, from: data)
    }
}
