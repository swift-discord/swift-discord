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
    public init(channelID: Snowflake, session: RESTSession, rateLimit: inout RateLimit) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "channels/\(channelID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            self = try JSONDecoder.discord.decode(Channel.self, from: data)
        } catch {
            if let error = try? JSONDecoder.discord.decode(RateLimitError.self, from: data) {
                throw error
            }
            if let error = try? JSONDecoder.discord.decode(RESTError.self, from: data) {
                throw error
            }
            throw error
        }
    }

    @inlinable
    public init(channelID: Snowflake, session: RESTSession) async throws {
        var rateLimit = RateLimit()
        try await self.init(channelID: channelID, session: session, rateLimit: &rateLimit)
    }
}

extension Channel {
    public static func channels(forGuildID guildID: Snowflake, session: RESTSession, rateLimit: inout RateLimit) async throws -> [Channel] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "guilds/\(guildID)/channels", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            return try JSONDecoder.discord.decode([Channel].self, from: data)
        } catch {
            if let error = try? JSONDecoder.discord.decode(RateLimitError.self, from: data) {
                throw error
            }
            if let error = try? JSONDecoder.discord.decode(RESTError.self, from: data) {
                throw error
            }
            throw error
        }
    }

    @inlinable
    public static func channels(forGuildID guildID: Snowflake, session: RESTSession) async throws -> [Channel] {
        var rateLimit = RateLimit()
        return try await channels(forGuildID: guildID, session: session, rateLimit: &rateLimit)
    }
}
