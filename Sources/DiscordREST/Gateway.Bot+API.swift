//
//  Gateway.Bot+API.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Gateway.Bot {

    public init(session: RESTSession, rateLimit: inout RateLimit) async throws {
        let urlRequest =
            URLRequest(
                url: .init(
                    discordAPIPath: "gateway/bot",
                    apiVersion: session.configuration.apiVersion)!)
        let (data, urlResponse) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            rateLimit = httpURLResponse.rateLimit
        }
        do {
            self = try JSONDecoder.discord.decode(Self.self, from: data)
        }
        catch {
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
    public init(session: RESTSession) async throws {
        var rateLimit = RateLimit()
        try await self.init(session: session, rateLimit: &rateLimit)
    }
}
