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
import Discord

extension User {
    public static func me(session: Session) async throws -> User {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/users/@me")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let user = try JSONDecoder.discord.decode(User.self, from: data)

        return user
    }
}

extension User {
    public init(userID: Snowflake, session: Session) async throws {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "v10/users/\(userID.rawValue)")!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        self = try JSONDecoder.discord.decode(User.self, from: data)
    }
}
