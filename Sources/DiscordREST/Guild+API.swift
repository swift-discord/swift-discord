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

extension Guild {
    public static func myGuilds(session: RESTSession) async throws -> [Guild] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/@me/guilds", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let guilds = try JSONDecoder.discord.decode([Guild].self, from: data)

        return guilds
    }
}

extension Guild {
    public init(guildID: Snowflake, session: RESTSession) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "guilds/\(guildID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(Guild.self, from: data)
    }
}
