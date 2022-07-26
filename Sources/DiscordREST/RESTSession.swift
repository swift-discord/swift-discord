//
//  RESTSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public actor RESTSession {
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

extension RESTSession {
    public func updateOAuth2Credential(_ oAuth2Credential: OAuth2Credential?) {
        self.oAuth2Credential = oAuth2Credential
    }
}

extension RESTSession {
    public func data(for request: URLRequest, includesOAuth2Credential: Bool = false) async throws -> (Data, URLResponse) {
        var request = request

        if includesOAuth2Credential, let oAuth2Credential = oAuth2Credential {
            guard oAuth2Credential.isValid else {
                try await refreshOAuth2Credential()
                return try await data(for: request, includesOAuth2Credential: includesOAuth2Credential)
            }

            request.setValue([oAuth2Credential.tokenType, oAuth2Credential.accessToken].joined(separator: " "), forHTTPHeaderField: "Authorization")
        }

        #if !canImport(FoundationNetworking)
        let (data, response) = try await { () -> (Data, URLResponse) in
            if #available(iOS 15.0, macOS 13.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *) {
                return try await urlSession.data(for: request)
            } else {
                return try await urlSession._data(for: request)
            }
        }()
        #else
        let (data, response) = try await urlSession._data(for: request)
        #endif

        return (data, response)
    }
}
