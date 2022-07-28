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
    public static func myGuilds(session: RESTSession, rateLimit: inout RateLimit) async throws -> [Guild] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/@me/guilds", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            return try JSONDecoder.discord.decode([Guild].self, from: data)
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
    public static func myGuilds(session: RESTSession) async throws -> [Guild] {
        var rateLimit = RateLimit()
        return try await myGuilds(session: session, rateLimit: &rateLimit)
    }
}

extension Guild {
    public init(guildID: Snowflake, session: RESTSession, rateLimit: inout RateLimit) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "guilds/\(guildID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            self = try JSONDecoder.discord.decode(Guild.self, from: data)
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
    public init(guildID: Snowflake, session: RESTSession) async throws {
        var rateLimit = RateLimit()
        try await self.init(guildID: guildID, session: session, rateLimit: &rateLimit)
    }
}
