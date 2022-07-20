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

    nonisolated let urlSession: URLSession

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
