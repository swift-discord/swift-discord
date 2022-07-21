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
        let session = Self.session
        await session.updateOAuth2Credential(Self.oAuth2Credential)

        let gatewaySession = GatewaySession(session: session)
        try await gatewaySession.connect()

        withExtendedLifetime(gatewaySession) {
            let expectation = XCTestExpectation()

            wait(for: [expectation], timeout: 120)
        }
    }
}
