//
//  UserAPITests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordRESTModel
@testable import DiscordREST

final class UserAPITests: TestCase {
    var session: RESTSession!

    override func setUp() async throws {
        session = Self.session

        try XCTSkipIf(Self.oAuth2Credential == nil, "oAuth2Credential not available.")
        await session.updateOAuth2Credential(Self.oAuth2Credential)
    }

    override func tearDown() async throws {

    }

    func testMe() async throws {
        let user = try await User.me(session: session)

        XCTAssertEqual(user.id, 999234842573164686)
        XCTAssertEqual(user.username, "Swifty Test Bot")
        XCTAssertEqual(user.discriminator, "7580")
        XCTAssertEqual(user.avatar, nil)
        XCTAssertEqual(user.bot, true)
        XCTAssertEqual(user.banner, nil)
        XCTAssertEqual(user.accentColor, nil)
        XCTAssertEqual(user.locale, "en-US")
        XCTAssertEqual(user.verified, true)
        XCTAssertEqual(user.email, nil)
        XCTAssertEqual(user.flags, [])
        XCTAssertEqual(user.premiumType, nil)
        XCTAssertEqual(user.publicFlags, [])
    }

    func testInitByUserID() async throws {
        let user = try await User(userID: 999234842573164686, session: session)

        XCTAssertEqual(user.id, 999234842573164686)
        XCTAssertEqual(user.username, "Swifty Test")
        XCTAssertEqual(user.discriminator, "7580")
        XCTAssertEqual(user.avatar, nil)
        XCTAssertEqual(user.bot, true)
        XCTAssertEqual(user.banner, nil)
        XCTAssertEqual(user.accentColor, nil)
        XCTAssertEqual(user.locale, nil)
        XCTAssertEqual(user.verified, nil)
        XCTAssertEqual(user.email, nil)
        XCTAssertEqual(user.flags, nil)
        XCTAssertEqual(user.premiumType, nil)
        XCTAssertEqual(user.publicFlags, [])
    }
}
