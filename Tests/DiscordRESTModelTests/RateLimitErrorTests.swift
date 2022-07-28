//
//  RateLimitErrorTests.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import _DiscordTestSupport

@testable
import DiscordRESTModel

final class RateLimitErrorTests: XCTestCase {

    func testDecodingExampleExceededUserRateLimitResponse() async throws {
        let exampleResponse =
            """
            {
              "message": "You are being rate limited.",
              "retry_after": 64.57,
              "global": false
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let rateLimit = try jsonDecoder.decode(RateLimitError.self, from: exampleResponse)
        XCTAssertEqual(rateLimit.message, "You are being rate limited.")
        XCTAssertEqual(rateLimit.retryAfterSeconds, 64.57, accuracy: 0.01)
        XCTAssertEqual(rateLimit.isGlobal, false)
    }

    func testDecodingExampleExceededResourceRateLimitResponse() async throws {
        let exampleResponse =
            """
            {
              "message": "The resource is being rate limited.",
              "retry_after": 1336.57,
              "global": false
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let rateLimit = try jsonDecoder.decode(RateLimitError.self, from: exampleResponse)
        XCTAssertEqual(rateLimit.message, "The resource is being rate limited.")
        XCTAssertEqual(rateLimit.retryAfterSeconds, 1336.57, accuracy: 0.01)
        XCTAssertEqual(rateLimit.isGlobal, false)
    }

    func testDecodingExampleExceededGlobalRateLimitResponse() async throws {
        let exampleResponse =
            """
            {
              "message": "You are being rate limited.",
              "retry_after": 64.57,
              "global": true
            }
            """
            .data(using: .utf8)!
        let jsonDecoder = JSONDecoder.discord
        let rateLimit = try jsonDecoder.decode(RateLimitError.self, from: exampleResponse)
        XCTAssertEqual(rateLimit.message, "You are being rate limited.")
        XCTAssertEqual(rateLimit.retryAfterSeconds, 64.57, accuracy: 0.01)
        XCTAssertEqual(rateLimit.isGlobal, true)
    }
}
