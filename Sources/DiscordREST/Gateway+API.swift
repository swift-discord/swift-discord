//
//  Gateway+API.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Gateway {

    public init(session: RESTSession) async throws {
        let urlRequest =
            URLRequest(
                url: .init(
                    discordAPIPath: "gateway",
                    apiVersion: session.configuration.apiVersion)!)
        let (data, _) = try await session.data(for: urlRequest)
        self = try JSONDecoder.discord.decode(Self.self, from: data)
    }
}
