//
//  Gateway_BotTests.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import _DiscordTestSupport

@testable
import DiscordRESTModel

final class Gateway_BotTests: XCTestCase {

    func testDecodingBotObjectExample() throws {
        let exampleResponse =
            """
            {
              "url": "wss://gateway.discord.gg/",
              "shards": 9,
              "session_start_limit": {
                "total": 1000,
                "remaining": 999,
                "reset_after": 14400000,
                "max_concurrency": 1
              }
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let bot = try jsonDecoder.decode(Gateway.Bot.self, from: exampleResponse)
        XCTAssertEqual(bot.url, .init(string: "wss://gateway.discord.gg/")!)
        XCTAssertEqual(bot.shards, 9)
        XCTAssertEqual(bot.sessionStartLimit.total, 1000)
        XCTAssertEqual(bot.sessionStartLimit.remaining, 999)
        XCTAssertEqual(bot.sessionStartLimit.resetAfterSeconds, 14400)
        XCTAssertEqual(bot.sessionStartLimit.maxConcurrency, 1)
    }
}
