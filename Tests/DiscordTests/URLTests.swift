//
//  URLTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import _DiscordTestSupport
@testable import Discord

final class URLTests: TestCase {
    func testDiscordAPIBaseURL() throws {
        XCTAssertEqual(URL.discordAPIBaseURL.absoluteString, "https://discord.com/api")
    }

    func testDiscordAPIPathInit() throws {
        let oAuth2Authorize = URL(discordAPIPath: "oauth2/authorize")
        XCTAssertEqual(oAuth2Authorize?.absoluteString, "https://discord.com/api/oauth2/authorize")

        let oAuth2Token = URL(discordAPIPath: "oauth2/token")
        XCTAssertEqual(oAuth2Token?.absoluteString, "https://discord.com/api/oauth2/token")

        let oAuth2TokenRevoke = URL(discordAPIPath: "oauth2/token/revoke")
        XCTAssertEqual(oAuth2TokenRevoke?.absoluteString, "https://discord.com/api/oauth2/token/revoke")
    }
}
