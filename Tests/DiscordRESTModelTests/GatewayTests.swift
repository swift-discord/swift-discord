//
//  GatewayTests.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import _DiscordTestSupport

@testable
import DiscordRESTModel

final class GatewayTests: XCTestCase {

    func testDecodingGatewayObjectExample() throws {
        let exampleResponse =
            """
            {
              "url": "wss://gateway.discord.gg/"
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let gateway = try jsonDecoder.decode(Gateway.self, from: exampleResponse)
        XCTAssertEqual(gateway.url, .init(string: "wss://gateway.discord.gg/")!)
    }
}
