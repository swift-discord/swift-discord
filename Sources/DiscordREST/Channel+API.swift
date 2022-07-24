//
//  Channel+API.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Channel {
    public init(channelID: Snowflake, session: Session) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "channels/\(channelID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(Channel.self, from: data)
    }
}

extension Channel {
    public static func channels(forGuildID guildID: Snowflake, session: Session) async throws -> [Channel] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "guilds/\(guildID)/channels", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let channels = try JSONDecoder.discord.decode([Channel].self, from: data)

        return channels
    }
}
