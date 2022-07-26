//
//  Session+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import DiscordCore

extension Session {
    public struct Configuration {
        public let urlSessionConfiguration: URLSessionConfiguration

        public let apiVersion: DiscordAPIVersion

        public let oAuth2ClientID: String?
        public let oAuth2ClientSecret: String?

        public init(
            urlSessionConfiguration: URLSessionConfiguration,
            apiVersion: DiscordAPIVersion = .v10,
            oAuth2ClientID: String? = nil,
            oAuth2ClientSecret: String? = nil
        ) {
            self.urlSessionConfiguration = urlSessionConfiguration
            self.apiVersion = apiVersion
            self.oAuth2ClientID = oAuth2ClientID
            self.oAuth2ClientSecret = oAuth2ClientSecret
        }
    }
}
