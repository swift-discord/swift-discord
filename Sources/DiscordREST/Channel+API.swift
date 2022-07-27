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
    public init(channelID: Snowflake, session: RESTSession) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "channels/\(channelID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        do {
            self = try JSONDecoder.discord.decode(Channel.self, from: data)
        } catch {
            if let error = try? JSONDecoder.discord.decode(RESTError.self, from: data) {
                throw error
            }
            throw error
        }
    }
}

extension Channel {
    public static func channels(forGuildID guildID: Snowflake, session: RESTSession) async throws -> [Channel] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "guilds/\(guildID)/channels", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        do {
            return try JSONDecoder.discord.decode([Channel].self, from: data)
        } catch {
            if let error = try? JSONDecoder.discord.decode(RESTError.self, from: data) {
                throw error
            }
            throw error
        }
    }
}
