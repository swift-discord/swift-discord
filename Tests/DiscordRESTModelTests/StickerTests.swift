//
//  StickerTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordRESTModel
@testable import DiscordREST

final class StickerTests: XCTestCase {
    func testDecodingStickerExample() throws {
        let exampleResponse = #"""
        {
          "id": "749054660769218631",
          "name": "Wave",
          "tags": "wumpus, hello, sup, hi, oi, heyo, heya, yo, greetings, greet, welcome, wave, :wave, :hello, :hi, :hey, hey, \ud83d\udc4b, \ud83d\udc4b\ud83c\udffb, \ud83d\udc4b\ud83c\udffc, \ud83d\udc4b\ud83c\udffd, \ud83d\udc4b\ud83c\udffe, \ud83d\udc4b\ud83c\udfff, goodbye, bye, see ya, later, laterz, cya",
          "type": 1,
          "format_type": 3,
          "description": "Wumpus waves hello",
          "asset": "",
          "pack_id": "847199849233514549",
          "sort_value": 12
        }
        """#.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let sticker = try jsonDecoder.decode(Sticker.self, from: exampleResponse)

        XCTAssertEqual(sticker.id, 749054660769218631)

        XCTAssertEqual(sticker.packID, 847199849233514549)
        XCTAssertEqual(sticker.name, "Wave")
        XCTAssertEqual(sticker.description, "Wumpus waves hello")
        XCTAssertEqual(sticker.tags, "wumpus, hello, sup, hi, oi, heyo, heya, yo, greetings, greet, welcome, wave, :wave, :hello, :hi, :hey, hey, 👋, 👋🏻, 👋🏼, 👋🏽, 👋🏾, 👋🏿, goodbye, bye, see ya, later, laterz, cya")

        XCTAssertEqual(sticker.type, .value(.standard))
        XCTAssertEqual(sticker.formatType, .value(.lottie))
        XCTAssertEqual(sticker.isAvailable, nil)

        XCTAssertEqual(sticker.guildID, nil)
        XCTAssertEqual(sticker.user, nil)

        XCTAssertEqual(sticker.sortValue, 12)
    }
}
