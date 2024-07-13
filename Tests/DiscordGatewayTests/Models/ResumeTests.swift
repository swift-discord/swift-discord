//
//  ResumeTests.swift
//  
//
//  Created by Mina Her on 2022/08/02.
//

import _DiscordTestSupport

@testable
import DiscordGatewayModel

final class ResumeTests: XCTestCase {

    let jsonDecoder: JSONDecoder = .discord

    func testDecodingExampleResume() throws {
        let exampleData =
            """
            {
              "token": "randomstring",
              "session_id": "evenmorerandomstring",
              "seq": 1337
            }
            """
            .data(using: .utf8)!
        let resume = try jsonDecoder.decode(Resume.self, from: exampleData)
        XCTAssertEqual(resume.token, "randomstring")
        XCTAssertEqual(resume.sessionID, "evenmorerandomstring")
        XCTAssertEqual(resume.sequence, 1337)
    }
}
