//
//  TestCase.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

#if canImport(GlibC)
import GlibC
#endif
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Discord

open class TestCase: XCTestCase {
    open class var oAuth2ClientID: String? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_CLIENT_ID"]
    }

    open class var oAuth2ClientSecret: String? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_CLIENT_SECRET"]
    }

    open class var oAuth2TokenType: String? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_TOKEN_TYPE"]
    }

    open class var oAuth2AccessToken: String? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_ACCESS_TOKEN"]
    }

    open class var oAuth2TokenExpires: Date? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_TOKEN_EXPIRES"].flatMap {
            TimeInterval($0)
                .flatMap {
                    Date(timeIntervalSince1970: $0)
                }
        }
    }

    open class var oAuth2RefreshToken: String? {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_REFRESH_TOKEN"]
    }

    open class var sessionConfiguration: RESTSession.Configuration {
        let urlSessionConfiguration = URLSessionConfiguration.default

        return RESTSession.Configuration(
            urlSessionConfiguration: urlSessionConfiguration,
            oAuth2ClientID: Self.oAuth2ClientID,
            oAuth2ClientSecret: Self.oAuth2ClientSecret
        )
    }

    open class var oAuth2Credential: OAuth2Credential? {
        guard
            let tokenType = oAuth2TokenType,
            let accessToken = oAuth2AccessToken
        else {
            return nil
        }

        return OAuth2Credential(
            tokenType: tokenType,
            accessToken: accessToken,
            expires: oAuth2TokenExpires,
            refreshToken: oAuth2RefreshToken,
            scopes: []
        )
    }

    open class var session: RESTSession {
        RESTSession(configuration: Self.sessionConfiguration)
    }

    open override class func setUp() {
        super.setUp()

        #if canImport(GlibC)
        setbuf(stdout, nil)
        #endif
    }
}
