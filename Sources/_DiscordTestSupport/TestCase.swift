//
//  TestCase.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import Discord

open class TestCase: XCTestCase {
    open class var oAuth2ClientID: String {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_CLIENT_ID"]!
    }

    open class var oAuth2ClientSecret: String {
        ProcessInfo.processInfo.environment["DISCORD_OAUTH2_CLIENT_SECRET"]!
    }

    open class var sessionConfiguration: Session.Configuration {
        let urlSessionConfiguration = URLSessionConfiguration.default

        return Session.Configuration(
            urlSessionConfiguration: urlSessionConfiguration,
            oAuth2ClientID: Self.oAuth2ClientID,
            oAuth2ClientSecret: Self.oAuth2ClientSecret
        )
    }

    open class var session: Session {
        Session(configuration: Self.sessionConfiguration)
    }
}
