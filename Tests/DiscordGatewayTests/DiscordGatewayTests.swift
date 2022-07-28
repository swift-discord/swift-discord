//
//  DiscordGatewayTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import _DiscordTestSupport
import DiscordREST

@testable
import DiscordGateway

final class DiscordGatewayTests: TestCase {
    func testMain() async throws {
        guard let authenticationToken = Self.oAuth2Credential?.accessToken else {
            throw XCTSkip("oAuth2Credential not available.")
        }
        let gateway = try await Gateway(session: Self.session)
        let gatewaySession = GatewaySession(authenticationToken: authenticationToken)
        print(gateway)
        try await gatewaySession.connect(url: gateway.url)

        withExtendedLifetime(gatewaySession) {
            let expectation = XCTestExpectation()

            wait(for: [expectation], timeout: 120)
        }
    }
}
