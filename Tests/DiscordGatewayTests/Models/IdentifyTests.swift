//
//  IdentifyTests.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

import _DiscordTestSupport

@testable
import DiscordGatewayModel

final class IdentifyTests: XCTestCase {

    let jsonDecoder: JSONDecoder = .discord

    func testDecodingExampleIdentify() throws {
        let exampleData =
            """
            {
              "token": "my_token",
              "properties": {
                "os": "linux",
                "browser": "disco",
                "device": "disco"
              },
              "compress": true,
              "large_threshold": 250,
              "shard": [0, 1],
              "presence": {
                "activities": [{
                  "name": "Cards Against Humanity",
                  "type": 0
                }],
                "status": "dnd",
                "since": 91879201,
                "afk": false
              },
              "intents": 7
            }
            """
            .data(using: .utf8)!
        let identify = try jsonDecoder.decode(Identify.self, from: exampleData)
        XCTAssertEqual(identify.token, "my_token")
        XCTAssertEqual(identify.properties.os, "linux")
        XCTAssertEqual(identify.properties.browser, "disco")
        XCTAssertEqual(identify.properties.device, "disco")
        XCTAssertEqual(identify.supportsCompression, true)
        XCTAssertEqual(identify.largeThreshold, 250)
        // TODO: shard
        //XCTAssertEqual(identify.shard, <#T##expression2: Equatable##Equatable#>)
        // skip identify.presence
        XCTAssertEqual(
            identify.intents,
            [.guilds,
             .guildMembers,
             .guildBans])
    }
}
