//
//  GatewayAPITests.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import _DiscordTestSupport

@testable
import DiscordREST

final class GatewayAPITests: TestCase {

    private var session: RESTSession!

    override func setUp() async throws {
        try await super.setUp()
        session = Self.session
        await session.updateOAuth2Credential(Self.oAuth2Credential)
    }

    override func tearDown() async throws {
        session = nil
        try await super.tearDown()
    }

    func testInit() async throws {
        let gateway = try await Gateway(session: session)
        if gateway.url.lastPathComponent.last == "/" {
            XCTAssertEqual(gateway.url, .init(string: "wss://gateway.discord.gg/")!)
        }
        else {
            XCTAssertEqual(gateway.url, .init(string: "wss://gateway.discord.gg")!)
        }
    }

    func testBotInit() async throws {
        try XCTSkipIf(Self.oAuth2Credential == nil, "oAuth2Credential is nil")
        try XCTSkipUnless(Self.oAuth2TokenType == "Bot", "oAuth2TokenType is not equal to Bot")
        let bot: Gateway.Bot
        bot = try await Gateway.Bot(session: session)
        if bot.url.lastPathComponent.last == "/" {
            XCTAssertEqual(bot.url, .init(string: "wss://gateway.discord.gg/")!)
        }
        else {
            XCTAssertEqual(bot.url, .init(string: "wss://gateway.discord.gg")!)
        }
        XCTAssertGreaterThan(bot.shards, 0)
        XCTAssertEqual(bot.sessionStartLimit.total, bot.shards + bot.sessionStartLimit.remaining)
        XCTAssertEqual(bot.sessionStartLimit.remaining, bot.sessionStartLimit.total - bot.shards)
        XCTAssertNotEqual(bot.sessionStartLimit.resetAfterSeconds, .nan)
        XCTAssertGreaterThan(bot.sessionStartLimit.maxConcurrency, 0)
    }
}
