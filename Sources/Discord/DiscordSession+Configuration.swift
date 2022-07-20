//
//  DiscordSession+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation

extension DiscordSession {
    public struct Configuration: Sendable {
        public let urlSessionConfiguration: URLSessionConfiguration

        public let oAuth2ClientID: String
        public let oAuth2ClientSecret: String

        public init(urlSessionConfiguration: URLSessionConfiguration, oAuth2ClientID: String, oAuth2ClientSecret: String) {
            self.urlSessionConfiguration = urlSessionConfiguration
            self.oAuth2ClientID = oAuth2ClientID
            self.oAuth2ClientSecret = oAuth2ClientSecret
        }
    }
}
