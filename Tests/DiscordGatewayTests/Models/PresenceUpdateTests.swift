//
//  PresenceUpdateTests.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

import _DiscordTestSupport

@testable
import DiscordGatewayModel

final class PresenceUpdateTests: XCTestCase {

    let jsonDecoder: JSONDecoder = .discord

    func testDecodingExamplePresenceUpdate() throws {
        let exampleData =
            """
            {
              "since": 91879201,
              "activities": [{
                "name": "Save the Oxford Comma",
                "type": 0
              }],
              "status": "online",
              "afk": false
            }
            """
            .data(using: .utf8)!
        let presenceUpdate = try jsonDecoder.decode(PresenceUpdate.self, from: exampleData)
        XCTAssertEqual(presenceUpdate.sinceDate, .init(timeIntervalSince1970: 91879.201))
        // skip presenceUpdate.activities
        XCTAssertEqual(presenceUpdate.status, .online)
        XCTAssertEqual(presenceUpdate.afk, false)
    }
}
