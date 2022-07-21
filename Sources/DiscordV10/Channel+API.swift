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
import Discord

extension Channel {
    public init(channelID: Snowflake, session: Session) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/channels/\(channelID.rawValue)")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(Channel.self, from: data)
    }
}

extension Channel {
    public static func channels(forGuildID guildID: Snowflake, session: Session) async throws -> [Channel] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/guilds/\(guildID)/channels")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let channels = try JSONDecoder.discord.decode([Channel].self, from: data)

        return channels
    }
}
