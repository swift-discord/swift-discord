//
//  UserTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import _DiscordTestSupport
@testable import Discord
@testable import DiscordV10

final class UserTests: TestCase {
    func testDecoding() throws {
        let exampleUserResponse = """
        {
          "id": "80351110224678912",
          "username": "Nelly",
          "discriminator": "1337",
          "avatar": "8342729096ea3675442027381ff50dfe",
          "verified": true,
          "email": "nelly@discord.com",
          "flags": 64,
          "banner": "06c16474723fe537c283b8efa61a30c8",
          "accent_color": 16711680,
          "premium_type": 1,
          "public_flags": 64
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let user = try jsonDecoder.decode(User.self, from: exampleUserResponse)

        XCTAssertEqual(user.id, 80351110224678912)

        XCTAssertEqual(user.username, "Nelly")
        XCTAssertEqual(user.discriminator, "1337")

        XCTAssertEqual(user.avatar, "8342729096ea3675442027381ff50dfe")

        XCTAssertEqual(user.bot, nil)
        XCTAssertEqual(user.system, nil)
        XCTAssertEqual(user.mfaEnabled, nil)
        XCTAssertEqual(user.banner, "06c16474723fe537c283b8efa61a30c8")
        XCTAssertEqual(user.accentColor, 16711680)
        XCTAssertEqual(user.locale, nil)
        XCTAssertEqual(user.verified, true)
        XCTAssertEqual(user.email, "nelly@discord.com")

        XCTAssertEqual(user.flags, [.hypeSquadOnlineHouse1])
        XCTAssertEqual(user.premiumType, .value(.nitroClassic))
        XCTAssertEqual(user.publicFlags, [.hypeSquadOnlineHouse1])
    }
}
