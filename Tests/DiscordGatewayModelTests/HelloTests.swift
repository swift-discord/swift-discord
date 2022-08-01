//
//  HelloTests.swift
//  
//
//  Created by Mina Her on 2022/08/02.
//

import _DiscordTestSupport

@testable
import DiscordGatewayModel

final class HelloTests: XCTestCase {

    let jsonDecoder: JSONDecoder = .discord

    func testDecodingExampleHello() throws {
        let exampleData =
            """
            {
              "heartbeat_interval": 45000
            }
            """
            .data(using: .utf8)!
        let hello = try jsonDecoder.decode(Hello.self, from: exampleData)
        XCTAssertEqual(hello.heartbeatInterval, 45000)
    }
}
