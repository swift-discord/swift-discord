//
//  GuildAPITests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import Discord
@testable import DiscordV10

final class GuildAPITests: TestCase {
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

    func testMyGuilds() async throws {
        let guilds = try await Guild.myGuilds(session: session)

        XCTAssertTrue(guilds.contains(where: { $0.id == 999525887206756372 }))
    }

    func testInitByUserID() async throws {
        let guild = try await Guild(guildID: 999525887206756372, session: session)

        XCTAssertEqual(guild.id, 999525887206756372)
    }
}
