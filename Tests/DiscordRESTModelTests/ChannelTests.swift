//
//  ChannelTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordRESTModel

final class ChannelTests: TestCase {
    func testDecodingGuildTextChannelExample() throws {
        let exampleResponse = """
        {
          "id": "41771983423143937",
          "guild_id": "41771983423143937",
          "name": "general",
          "type": 0,
          "position": 6,
          "permission_overwrites": [],
          "rate_limit_per_user": 2,
          "nsfw": true,
          "topic": "24/7 chat about how to gank Mike #2",
          "last_message_id": "155117677105512449",
          "parent_id": "399942396007890945",
          "default_auto_archive_duration": 60
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 41771983423143937)

        XCTAssertEqual(channel.type, .value(.guildText))

        XCTAssertEqual(channel.guildID, 41771983423143937)

        XCTAssertEqual(channel.position, 6)

        XCTAssertEqual(channel.permissionOverwrites, [])

        XCTAssertEqual(channel.name, "general")
        XCTAssertEqual(channel.topic, "24/7 chat about how to gank Mike #2")

        XCTAssertEqual(channel.isNSFW, true)

        XCTAssertEqual(channel.lastMessageID, 155117677105512449)

        XCTAssertEqual(channel.bitrate, nil)
        XCTAssertEqual(channel.userLimit, nil)
        XCTAssertEqual(channel.rateLimitPerUser, 2)

        XCTAssertEqual(channel.recipients, nil)

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, nil)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, 399942396007890945)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, 60)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }

    func testDecodingGuildNewsChannelExample() throws {
        let exampleResponse = """
        {
          "id": "41771983423143937",
          "guild_id": "41771983423143937",
          "name": "important-news",
          "type": 5,
          "position": 6,
          "permission_overwrites": [],
          "nsfw": true,
          "topic": "Rumors about Half Life 3",
          "last_message_id": "155117677105512449",
          "parent_id": "399942396007890945",
          "default_auto_archive_duration": 60
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 41771983423143937)

        XCTAssertEqual(channel.type, .value(.guildNews))

        XCTAssertEqual(channel.guildID, 41771983423143937)

        XCTAssertEqual(channel.position, 6)

        XCTAssertEqual(channel.permissionOverwrites, [])

        XCTAssertEqual(channel.name, "important-news")
        XCTAssertEqual(channel.topic, "Rumors about Half Life 3")

        XCTAssertEqual(channel.isNSFW, true)

        XCTAssertEqual(channel.lastMessageID, 155117677105512449)

        XCTAssertEqual(channel.bitrate, nil)
        XCTAssertEqual(channel.userLimit, nil)
        XCTAssertEqual(channel.rateLimitPerUser, nil)

        XCTAssertEqual(channel.recipients, nil)

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, nil)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, 399942396007890945)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, 60)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }

    func testDecodingGuildVoiceChannelExample() throws {
        let exampleResponse = """
        {
          "id": "155101607195836416",
          "guild_id": "41771983423143937",
          "name": "ROCKET CHEESE",
          "type": 2,
          "nsfw": false,
          "position": 5,
          "permission_overwrites": [],
          "bitrate": 64000,
          "user_limit": 0,
          "parent_id": null,
          "rtc_region": null
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 155101607195836416)

        XCTAssertEqual(channel.type, .value(.guildVoice))

        XCTAssertEqual(channel.guildID, 41771983423143937)

        XCTAssertEqual(channel.position, 5)

        XCTAssertEqual(channel.permissionOverwrites, [])

        XCTAssertEqual(channel.name, "ROCKET CHEESE")
        XCTAssertEqual(channel.topic, nil)

        XCTAssertEqual(channel.isNSFW, false)

        XCTAssertEqual(channel.lastMessageID, nil)

        XCTAssertEqual(channel.bitrate, 64000)
        XCTAssertEqual(channel.userLimit, 0)
        XCTAssertEqual(channel.rateLimitPerUser, nil)

        XCTAssertEqual(channel.recipients, nil)

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, nil)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, nil)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, nil)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }

    func testDecodingDMChannelExample() throws {
        let exampleResponse = """
        {
          "last_message_id": "3343820033257021450",
          "type": 1,
          "id": "319674150115610528",
          "recipients": [
            {
              "username": "test",
              "discriminator": "9999",
              "id": "82198898841029460",
              "avatar": "33ecab261d4681afa4d85a04691c4a01"
            }
          ]
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 319674150115610528)

        XCTAssertEqual(channel.type, .value(.dm))

        XCTAssertEqual(channel.guildID, nil)

        XCTAssertEqual(channel.position, nil)

        XCTAssertEqual(channel.permissionOverwrites, nil)

        XCTAssertEqual(channel.name, nil)
        XCTAssertEqual(channel.topic, nil)

        XCTAssertEqual(channel.isNSFW, nil)

        XCTAssertEqual(channel.lastMessageID, 3343820033257021450)

        XCTAssertEqual(channel.bitrate, nil)
        XCTAssertEqual(channel.userLimit, nil)
        XCTAssertEqual(channel.rateLimitPerUser, nil)

        XCTAssertEqual(channel.recipients?.count, 1)
        XCTAssertEqual(channel.recipients?[0].username, "test")
        XCTAssertEqual(channel.recipients?[0].discriminator, "9999")
        XCTAssertEqual(channel.recipients?[0].id, 82198898841029460)
        XCTAssertEqual(channel.recipients?[0].avatar, "33ecab261d4681afa4d85a04691c4a01")

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, nil)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, nil)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, nil)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }

    func testDecodingGroupDMChannelExample() throws {
        let exampleResponse = """
        {
          "name": "Some test channel",
          "icon": null,
          "recipients": [
            {
              "username": "test",
              "discriminator": "9999",
              "id": "82198898841029460",
              "avatar": "33ecab261d4681afa4d85a04691c4a01"
            },
            {
              "username": "test2",
              "discriminator": "9999",
              "id": "82198810841029460",
              "avatar": "33ecab261d4681afa4d85a10691c4a01"
            }
          ],
          "last_message_id": "3343820033257021450",
          "type": 3,
          "id": "319674150115710528",
          "owner_id": "82198810841029460"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 319674150115710528)

        XCTAssertEqual(channel.type, .value(.groupDM))

        XCTAssertEqual(channel.guildID, nil)

        XCTAssertEqual(channel.position, nil)

        XCTAssertEqual(channel.permissionOverwrites, nil)

        XCTAssertEqual(channel.name, "Some test channel")
        XCTAssertEqual(channel.topic, nil)

        XCTAssertEqual(channel.isNSFW, nil)

        XCTAssertEqual(channel.lastMessageID, 3343820033257021450)

        XCTAssertEqual(channel.bitrate, nil)
        XCTAssertEqual(channel.userLimit, nil)
        XCTAssertEqual(channel.rateLimitPerUser, nil)

        XCTAssertEqual(channel.recipients?.count, 2)
        XCTAssertEqual(channel.recipients?[0].username, "test")
        XCTAssertEqual(channel.recipients?[0].discriminator, "9999")
        XCTAssertEqual(channel.recipients?[0].id, 82198898841029460)
        XCTAssertEqual(channel.recipients?[0].avatar, "33ecab261d4681afa4d85a04691c4a01")
        XCTAssertEqual(channel.recipients?[1].username, "test2")
        XCTAssertEqual(channel.recipients?[1].discriminator, "9999")
        XCTAssertEqual(channel.recipients?[1].id, 82198810841029460)
        XCTAssertEqual(channel.recipients?[1].avatar, "33ecab261d4681afa4d85a10691c4a01")

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, 82198810841029460)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, nil)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, nil)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }

    func testDecodingChannelCategoryExample() throws {
        let exampleResponse = """
        {
          "permission_overwrites": [],
          "name": "Test",
          "parent_id": null,
          "nsfw": false,
          "position": 0,
          "guild_id": "290926798629997250",
          "type": 4,
          "id": "399942396007890945"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let channel = try jsonDecoder.decode(Channel.self, from: exampleResponse)

        XCTAssertEqual(channel.id, 399942396007890945)

        XCTAssertEqual(channel.type, .value(.guildCategory))

        XCTAssertEqual(channel.guildID, 290926798629997250)

        XCTAssertEqual(channel.position, 0)

        XCTAssertEqual(channel.permissionOverwrites, [])

        XCTAssertEqual(channel.name, "Test")
        XCTAssertEqual(channel.topic, nil)

        XCTAssertEqual(channel.isNSFW, false)

        XCTAssertEqual(channel.lastMessageID, nil)

        XCTAssertEqual(channel.bitrate, nil)
        XCTAssertEqual(channel.userLimit, nil)
        XCTAssertEqual(channel.rateLimitPerUser, nil)

        XCTAssertEqual(channel.recipients, nil)

        XCTAssertEqual(channel.icon, nil)

        XCTAssertEqual(channel.ownerID, nil)
        XCTAssertEqual(channel.applicationID, nil)
        XCTAssertEqual(channel.parentID, nil)

        XCTAssertEqual(channel.lastPinTimestamp, nil)

        XCTAssertEqual(channel.rtcRegion, nil)
        XCTAssertEqual(channel.videoQualityMode, nil)

        XCTAssertEqual(channel.messageCount, nil)
        XCTAssertEqual(channel.memberCount, nil)

        XCTAssertEqual(channel.threadMetadata, nil)
        XCTAssertEqual(channel.member, nil)

        XCTAssertEqual(channel.defaultAutoArchiveDuration, nil)
        XCTAssertEqual(channel.permissions, nil)
        XCTAssertEqual(channel.flags, nil)
    }
}
