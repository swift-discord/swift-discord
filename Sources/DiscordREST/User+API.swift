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
    public static func me(session: RESTSession) async throws -> User {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/@me", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        return try JSONDecoder.discord.decode(User.self, from: data)
    }
}

extension User {
    public init(userID: Snowflake, session: RESTSession) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "users/\(userID.rawValue)", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(User.self, from: data)
    }
}
