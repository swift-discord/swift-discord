//
//  DiscordGatewayTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import _DiscordTestSupport
@testable import Discord
@testable import DiscordGateway

final class DiscordGatewayTests: TestCase {
    func testMain() async throws {
        guard let authenticationToken = Self.oAuth2Credential?.accessToken else {
            throw XCTSkip("oAuth2Credential not available.")
        }

        let gatewaySession = GatewaySession(authenticationToken: authenticationToken)
        try await gatewaySession.connect()

        withExtendedLifetime(gatewaySession) {
            let expectation = XCTestExpectation()

            wait(for: [expectation], timeout: 120)
        }
    }
}
