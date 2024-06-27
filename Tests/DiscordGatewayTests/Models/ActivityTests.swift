//
//  ActivityTests.swift
//  
//
//  Created by Mina Her on 2022/08/02.
//

import _DiscordTestSupport

@testable
import DiscordGatewayModel

final class ActivityTests: XCTestCase {

    let jsonDecoder: JSONDecoder = .discord

    func testDecodingExampleActivity() throws {
        let exampleData =
            """
            {
              "details": "24H RL Stream for Charity",
              "state": "Rocket League",
              "name": "Twitch",
              "type": 1,
              "url": "https://www.twitch.tv/discord"
            }
            """
            .data(using: .utf8)!
        let activity = try jsonDecoder.decode(Activity.self, from: exampleData)
        XCTAssertEqual(activity.details, "24H RL Stream for Charity")
        XCTAssertEqual(activity.state, "Rocket League")
        XCTAssertEqual(activity.name, "Twitch")
        XCTAssertEqual(activity.type, .streaming)
        XCTAssertEqual(activity.url, .init(string: "https://www.twitch.tv/discord")!)
    }

    func testDecodingExampleActivityWithRichPresence() throws {
        let exampleData =
            """
            {
              "name": "Rocket League",
              "type": 0,
              "application_id": "379286085710381999",
              "state": "In a Match",
              "details": "Ranked Duos: 2-1",
              "timestamps": {
                "start": 15112000660000
              },
              "party": {
                "id": "9dd6594e-81b3-49f6-a6b5-a679e6a060d3",
                "size": [2, 2]
              },
              "assets": {
                "large_image": "351371005538729000",
                "large_text": "DFH Stadium",
                "small_image": "351371005538729111",
                "small_text": "Silver III"
              },
              "secrets": {
                "join": "025ed05c71f639de8bfaa0d679d7c94b2fdce12f",
                "spectate": "e7eb30d2ee025ed05c71ea495f770b76454ee4e0",
                "match": "4b2fdce12f639de8bfa7e3591b71a0d679d7c93f"
              }
            }
            """
            .data(using: .utf8)!
        let activity = try jsonDecoder.decode(Activity.self, from: exampleData)
        XCTAssertEqual(activity.name, "Rocket League")
        XCTAssertEqual(activity.type, .game)
        XCTAssertEqual(activity.applicationID, 379286085710381999)
        XCTAssertEqual(activity.state, "In a Match")
        XCTAssertEqual(activity.details, "Ranked Duos: 2-1")
        XCTAssertEqual(activity.timestamps?.startDate, .init(timeIntervalSince1970: 15112000660))
        XCTAssertEqual(activity.party?.id, "9dd6594e-81b3-49f6-a6b5-a679e6a060d3")
        XCTAssertEqual(activity.party?.size.current, 2)
        XCTAssertEqual(activity.party?.size.max, 2)
        XCTAssertEqual(activity.assets?.largeImage, .applicationAsset(id: 351371005538729000))
        XCTAssertEqual(activity.assets?.largeText, "DFH Stadium")
        XCTAssertEqual(activity.assets?.smallImage, .applicationAsset(id: 351371005538729111))
        XCTAssertEqual(activity.assets?.smallText, "Silver III")
        XCTAssertEqual(activity.secrets?.join, "025ed05c71f639de8bfaa0d679d7c94b2fdce12f")
        XCTAssertEqual(activity.secrets?.spectate, "e7eb30d2ee025ed05c71ea495f770b76454ee4e0")
        XCTAssertEqual(activity.secrets?.match, "4b2fdce12f639de8bfa7e3591b71a0d679d7c93f")
    }
}
