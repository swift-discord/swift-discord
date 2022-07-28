//
//  User+API.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension User {
    public static func me(session: RESTSession, rateLimit: inout RateLimit) async throws -> User {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/@me", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            return try JSONDecoder.discord.decode(User.self, from: data)
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
    public static func me(session: RESTSession) async throws -> User {
        var rateLimit = RateLimit()
        return try await me(session: session, rateLimit: &rateLimit)
    }
}

extension User {
    public init(userID: Snowflake, session: RESTSession, rateLimit: inout RateLimit) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/\(userID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }

        do {
            self = try JSONDecoder.discord.decode(User.self, from: data)
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
    public init(userID: Snowflake, session: RESTSession) async throws {
        var rateLimit = RateLimit()
        try await self.init(userID: userID, session: session, rateLimit: &rateLimit)
    }
}
