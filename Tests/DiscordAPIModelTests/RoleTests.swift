//
//  RoleTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordAPIModel

final class RoleTests: XCTestCase {
    func testDecodingRoleExample() throws {
        let exampleResponse = """
        {
          "id": "41771983423143936",
          "name": "WE DEM BOYZZ!!!!!!",
          "color": 3447003,
          "hoist": true,
          "icon": "cf3ced8600b777c9486c6d8d84fb4327",
          "unicode_emoji": null,
          "position": 1,
          "permissions": "66321471",
          "managed": false,
          "mentionable": false
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let role = try jsonDecoder.decode(Role.self, from: exampleResponse)

        XCTAssertEqual(role.id, 41771983423143936)

        XCTAssertEqual(role.name, "WE DEM BOYZZ!!!!!!")

        XCTAssertEqual(role.color, 3447003)
        XCTAssertEqual(role.hoist, true)
        XCTAssertEqual(role.icon, "cf3ced8600b777c9486c6d8d84fb4327")
        XCTAssertEqual(role.unicodeEmoji, nil)
        XCTAssertEqual(role.position, 1)

        XCTAssertEqual(role.permissions, "66321471")

        XCTAssertEqual(role.isManaged, false)
        XCTAssertEqual(role.isMentionable, false)

        XCTAssertEqual(role.tags, nil)
    }
}
