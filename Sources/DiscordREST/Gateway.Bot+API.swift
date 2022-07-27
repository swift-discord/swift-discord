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

    public init(session: RESTSession) async throws {
        let urlRequest =
            URLRequest(
                url: .init(
                    discordAPIPath: "gateway/bot",
                    apiVersion: session.configuration.apiVersion)!)
        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)
        do {
            self = try JSONDecoder.discord.decode(Self.self, from: data)
        }
        catch {
            if let error = try? JSONDecoder.discord.decode(RateLimit.self, from: data) {
                throw error
            }
            if let error = try? JSONDecoder.discord.decode(RESTError.self, from: data) {
                throw error
            }
            throw error
        }
    }
}
