//
//  Guild_WelcomeScreenTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordAPIModel

final class Guild_WelcomeScreenTests: XCTestCase {
    func testDecodingWelcomeScreenExample() throws {
        // swiftlint:disable all
        let exampleResponse = #"""
        {
          "description": "Discord Developers is a place to learn about Discord's API, bots, and SDKs and integrations. This is NOT a general Discord support server.",
          "welcome_channels": [
            {
              "channel_id": "697138785317814292",
              "description": "Follow for official Discord API updates",
              "emoji_id": null,
              "emoji_name": "📡"
            },
            {
              "channel_id": "697236247739105340",
              "description": "Get help with Bot Verifications",
              "emoji_id": null,
              "emoji_name": "📸"
            },
            {
              "channel_id": "697489244649816084",
              "description": "Create amazing things with Discord's API",
              "emoji_id": null,
              "emoji_name": "🔬"
            },
            {
              "channel_id": "613425918748131338",
              "description": "Integrate Discord into your game",
              "emoji_id": null,
              "emoji_name": "🎮"
            },
            {
              "channel_id": "646517734150242346",
              "description": "Find more places to help you on your quest",
              "emoji_id": null,
              "emoji_name": "🔦"
            }
          ]
        }
        """#.data(using: .utf8)!
        // swiftlint:enable all

        let jsonDecoder = JSONDecoder.discord

        let welcomeScreen = try jsonDecoder.decode(Guild.WelcomeScreen.self, from: exampleResponse)

        XCTAssertEqual(
            welcomeScreen.description,
            "Discord Developers is a place to learn about Discord's API, bots, and SDKs and integrations. This is NOT a general Discord support server."
        )

        XCTAssertEqual(welcomeScreen.welcomeChannels.count, 5)

        XCTAssertEqual(welcomeScreen.welcomeChannels[0].channelID, 697138785317814292)
        XCTAssertEqual(welcomeScreen.welcomeChannels[0].description, "Follow for official Discord API updates")
        XCTAssertEqual(welcomeScreen.welcomeChannels[0].emojiID, nil)
        XCTAssertEqual(welcomeScreen.welcomeChannels[0].emojiName, "📡")

        XCTAssertEqual(welcomeScreen.welcomeChannels[1].channelID, 697236247739105340)
        XCTAssertEqual(welcomeScreen.welcomeChannels[1].description, "Get help with Bot Verifications")
        XCTAssertEqual(welcomeScreen.welcomeChannels[1].emojiID, nil)
        XCTAssertEqual(welcomeScreen.welcomeChannels[1].emojiName, "📸")

        XCTAssertEqual(welcomeScreen.welcomeChannels[2].channelID, 697489244649816084)
        XCTAssertEqual(welcomeScreen.welcomeChannels[2].description, "Create amazing things with Discord's API")
        XCTAssertEqual(welcomeScreen.welcomeChannels[2].emojiID, nil)
        XCTAssertEqual(welcomeScreen.welcomeChannels[2].emojiName, "🔬")

        XCTAssertEqual(welcomeScreen.welcomeChannels[3].channelID, 613425918748131338)
        XCTAssertEqual(welcomeScreen.welcomeChannels[3].description, "Integrate Discord into your game")
        XCTAssertEqual(welcomeScreen.welcomeChannels[3].emojiID, nil)
        XCTAssertEqual(welcomeScreen.welcomeChannels[3].emojiName, "🎮")

        XCTAssertEqual(welcomeScreen.welcomeChannels[4].channelID, 646517734150242346)
        XCTAssertEqual(welcomeScreen.welcomeChannels[4].description, "Find more places to help you on your quest")
        XCTAssertEqual(welcomeScreen.welcomeChannels[4].emojiID, nil)
        XCTAssertEqual(welcomeScreen.welcomeChannels[4].emojiName, "🔦")
    }
}
