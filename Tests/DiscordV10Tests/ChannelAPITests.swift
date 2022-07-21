//
//  ChannelAPITests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import Discord
@testable import DiscordV10

final class ChannelAPITests: TestCase {
    var session: Session!

    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        session = Self.session

        try XCTSkipIf(Self.oAuth2Credential == nil, "oAuth2Credential not available.")
        await session.updateOAuth2Credential(Self.oAuth2Credential)
    }

    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitByChannelID() async throws {
        let channel = try await Channel(channelID: 999525888003678308, session: session)

        XCTAssertEqual(channel.id, 999525888003678308)
    }

    func testGetChannelsFromGuild() async throws {
        let channels = try await Channel.channels(forGuildID: 999525887206756372, session: session)

        XCTAssertEqual(channels.count, 11)
    }
}
