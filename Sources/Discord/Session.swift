//
//  Session.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public actor Session {
    public let configuration: Configuration
    public private(set) var oAuth2Credential: OAuth2Credential?

    private nonisolated let urlSession: URLSession

    public init(configuration: Configuration) {
        self.configuration = configuration
        self.urlSession = URLSession(configuration: configuration.urlSessionConfiguration)
    }

    deinit {
        urlSession.invalidateAndCancel()
    }
}

extension Session {
    public func updateOAuth2Credential(_ oAuth2Credential: OAuth2Credential?) {
        self.oAuth2Credential = oAuth2Credential
    }
}

extension Session {
    public nonisolated func data(for request: URLRequest, includesOAuth2Credential: Bool = false) async throws -> (Data, URLResponse) {
        var request = request

        if includesOAuth2Credential, let oAuth2Credential = await oAuth2Credential {
            request.setValue([oAuth2Credential.tokenType, oAuth2Credential.accessToken].joined(separator: " "), forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await urlSession.data(for: request)

        return (data, response)
    }
}
