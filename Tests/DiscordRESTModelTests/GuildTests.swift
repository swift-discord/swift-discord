//
//  GuildTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordRESTModel

final class GuildTests: TestCase {
    func testDecodingGuildObjectExample() throws {
        let exampleResponse = """
        {
          "id": "197038439483310086",
          "name": "Discord Testers",
          "icon": "f64c482b807da4f539cff778d174971c",
          "description": "The official place to report Discord Bugs!",
          "splash": null,
          "discovery_splash": null,
          "features": [
            "ANIMATED_ICON",
            "VERIFIED",
            "NEWS",
            "VANITY_URL",
            "DISCOVERABLE",
            "MORE_EMOJI",
            "INVITE_SPLASH",
            "BANNER",
            "COMMUNITY"
          ],
          "emojis": [],
          "banner": "9b6439a7de04f1d26af92f84ac9e1e4a",
          "owner_id": "73193882359173120",
          "application_id": null,
          "region": null,
          "afk_channel_id": null,
          "afk_timeout": 300,
          "system_channel_id": null,
          "widget_enabled": true,
          "widget_channel_id": null,
          "verification_level": 3,
          "roles": [],
          "default_message_notifications": 1,
          "mfa_level": 1,
          "explicit_content_filter": 2,
          "max_presences": 40000,
          "max_members": 250000,
          "vanity_url_code": "discord-testers",
          "premium_tier": 3,
          "premium_subscription_count": 33,
          "system_channel_flags": 0,
          "preferred_locale": "en-US",
          "rules_channel_id": "441688182833020939",
          "public_updates_channel_id": "281283303326089216"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let guild = try jsonDecoder.decode(Guild.self, from: exampleResponse)

        XCTAssertEqual(guild.id, 197038439483310086)

        XCTAssertNotEqual(guild.isUnavailable, true)

        XCTAssertEqual(guild.name, "Discord Testers")
        XCTAssertEqual(guild.icon, "f64c482b807da4f539cff778d174971c")
        XCTAssertEqual(guild.splash, nil)
        XCTAssertEqual(guild.discoverySplash, nil)

        XCTAssertEqual(guild.isOwner, nil)
        XCTAssertEqual(guild.ownerID, 73193882359173120)

        XCTAssertEqual(guild.permissions, nil)

        XCTAssertEqual(guild.afkChannelID, nil)
        XCTAssertEqual(guild.afkTimeout, 300)

        XCTAssertEqual(guild.isWidgetEnabled, true)
        XCTAssertEqual(guild.widgetChannelID, nil)

        XCTAssertEqual(guild.verificationLevel, .value(.high))

        XCTAssertEqual(guild.defaultMessageNotifications, .value(.onlyMentions))

        XCTAssertEqual(guild.explicitContentFilter, .value(.allMembers))

        XCTAssertEqual(guild.roles, [])
        XCTAssertEqual(guild.emojis, [])
        XCTAssertEqual(guild.features?.count, 9)

        XCTAssertEqual(guild.mfaLevel, .value(.elevated))

        XCTAssertEqual(guild.applicationID, nil)

        XCTAssertEqual(guild.systemChannelID, nil)
        XCTAssertEqual(guild.systemChannelFlags, [])

        XCTAssertEqual(guild.rulesChannelID, 441688182833020939)

        XCTAssertEqual(guild.maxPresences, 40000)
        XCTAssertEqual(guild.maxMembers, 250000)

        XCTAssertEqual(guild.vanityURLCode, "discord-testers")
        XCTAssertEqual(guild.description, "The official place to report Discord Bugs!")
        XCTAssertEqual(guild.banner, "9b6439a7de04f1d26af92f84ac9e1e4a")

        XCTAssertEqual(guild.premiumTier, .value(.tier3))
        XCTAssertEqual(guild.premiumSubscriptionCount, 33)

        XCTAssertEqual(guild.preferredLocale, "en-US")

        XCTAssertEqual(guild.publicUpdatesChannelID, 281283303326089216)

        XCTAssertEqual(guild.maxVideoChannelUsers, nil)

        XCTAssertEqual(guild.approximateMemberCount, nil)
        XCTAssertEqual(guild.approximatePresenceCount, nil)

        XCTAssertEqual(guild.welcomeScreen, nil)

        XCTAssertEqual(guild.nsfwLevel, nil)

        XCTAssertEqual(guild.stickers, nil)

        XCTAssertEqual(guild.isPremiumProgressBarEnabled, nil)
    }

    func testDecodingUnavailableGuildObjectExample() throws {
        let exampleResponse = """
        {
          "id": "41771983423143937",
          "unavailable": true
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let guild = try jsonDecoder.decode(Guild.self, from: exampleResponse)

        XCTAssertEqual(guild.id, 41771983423143937)

        XCTAssertEqual(guild.isUnavailable, true)

        XCTAssertEqual(guild.name, nil)
        XCTAssertEqual(guild.icon, nil)
        XCTAssertEqual(guild.splash, nil)
        XCTAssertEqual(guild.discoverySplash, nil)

        XCTAssertEqual(guild.isOwner, nil)
        XCTAssertEqual(guild.ownerID, nil)

        XCTAssertEqual(guild.permissions, nil)

        XCTAssertEqual(guild.afkChannelID, nil)
        XCTAssertEqual(guild.afkTimeout, nil)

        XCTAssertEqual(guild.isWidgetEnabled, nil)
        XCTAssertEqual(guild.widgetChannelID, nil)

        XCTAssertEqual(guild.verificationLevel, nil)

        XCTAssertEqual(guild.defaultMessageNotifications, nil)

        XCTAssertEqual(guild.explicitContentFilter, nil)

        XCTAssertEqual(guild.roles, nil)
        XCTAssertEqual(guild.emojis, nil)
        XCTAssertEqual(guild.features, nil)

        XCTAssertEqual(guild.mfaLevel, nil)

        XCTAssertEqual(guild.applicationID, nil)

        XCTAssertEqual(guild.systemChannelID, nil)
        XCTAssertEqual(guild.systemChannelFlags, nil)

        XCTAssertEqual(guild.rulesChannelID, nil)

        XCTAssertEqual(guild.maxPresences, nil)
        XCTAssertEqual(guild.maxMembers, nil)

        XCTAssertEqual(guild.vanityURLCode, nil)
        XCTAssertEqual(guild.description, nil)
        XCTAssertEqual(guild.banner, nil)

        XCTAssertEqual(guild.premiumTier, nil)
        XCTAssertEqual(guild.premiumSubscriptionCount, nil)

        XCTAssertEqual(guild.preferredLocale, nil)

        XCTAssertEqual(guild.publicUpdatesChannelID, nil)

        XCTAssertEqual(guild.maxVideoChannelUsers, nil)

        XCTAssertEqual(guild.approximateMemberCount, nil)
        XCTAssertEqual(guild.approximatePresenceCount, nil)

        XCTAssertEqual(guild.welcomeScreen, nil)

        XCTAssertEqual(guild.nsfwLevel, nil)

        XCTAssertEqual(guild.stickers, nil)

        XCTAssertEqual(guild.isPremiumProgressBarEnabled, nil)
    }

    func testDecodingGuildPreviewObjectExample() throws {
        let exampleResponse = """
        {
          "id": "197038439483310086",
          "name": "Discord Testers",
          "icon": "f64c482b807da4f539cff778d174971c",
          "splash": null,
          "discovery_splash": null,
          "emojis": [],
          "features": [
            "DISCOVERABLE",
            "VANITY_URL",
            "ANIMATED_ICON",
            "INVITE_SPLASH",
            "NEWS",
            "COMMUNITY",
            "BANNER",
            "VERIFIED",
            "MORE_EMOJI"
          ],
          "approximate_member_count": 60814,
          "approximate_presence_count": 20034,
          "description": "The official place to report Discord Bugs!",
          "stickers": []
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let guild = try jsonDecoder.decode(Guild.self, from: exampleResponse)

        XCTAssertEqual(guild.id, 197038439483310086)

        XCTAssertNotEqual(guild.isUnavailable, true)

        XCTAssertEqual(guild.name, "Discord Testers")
        XCTAssertEqual(guild.icon, "f64c482b807da4f539cff778d174971c")
        XCTAssertEqual(guild.splash, nil)
        XCTAssertEqual(guild.discoverySplash, nil)

        XCTAssertEqual(guild.isOwner, nil)
        XCTAssertEqual(guild.ownerID, nil)

        XCTAssertEqual(guild.permissions, nil)

        XCTAssertEqual(guild.afkChannelID, nil)
        XCTAssertEqual(guild.afkTimeout, nil)

        XCTAssertEqual(guild.isWidgetEnabled, nil)
        XCTAssertEqual(guild.widgetChannelID, nil)

        XCTAssertEqual(guild.verificationLevel, nil)

        XCTAssertEqual(guild.defaultMessageNotifications, nil)

        XCTAssertEqual(guild.explicitContentFilter, nil)

        XCTAssertEqual(guild.roles, nil)
        XCTAssertEqual(guild.emojis, [])
        XCTAssertEqual(guild.features?.count, 9)

        XCTAssertEqual(guild.mfaLevel, nil)

        XCTAssertEqual(guild.applicationID, nil)

        XCTAssertEqual(guild.systemChannelID, nil)
        XCTAssertEqual(guild.systemChannelFlags, nil)

        XCTAssertEqual(guild.rulesChannelID, nil)

        XCTAssertEqual(guild.maxPresences, nil)
        XCTAssertEqual(guild.maxMembers, nil)

        XCTAssertEqual(guild.vanityURLCode, nil)
        XCTAssertEqual(guild.description, "The official place to report Discord Bugs!")
        XCTAssertEqual(guild.banner, nil)

        XCTAssertEqual(guild.premiumTier, nil)
        XCTAssertEqual(guild.premiumSubscriptionCount, nil)

        XCTAssertEqual(guild.preferredLocale, nil)

        XCTAssertEqual(guild.publicUpdatesChannelID, nil)

        XCTAssertEqual(guild.maxVideoChannelUsers, nil)

        XCTAssertEqual(guild.approximateMemberCount, 60814)
        XCTAssertEqual(guild.approximatePresenceCount, 20034)

        XCTAssertEqual(guild.welcomeScreen, nil)

        XCTAssertEqual(guild.nsfwLevel, nil)

        XCTAssertEqual(guild.stickers, [])

        XCTAssertEqual(guild.isPremiumProgressBarEnabled, nil)
    }

    func testDecodingGetGuildExample() throws {
        let exampleResponse = """
        {
          "id": "2909267986263572999",
          "name": "Mason's Test Server",
          "icon": "389030ec9db118cb5b85a732333b7c98",
          "description": null,
          "splash": "75610b05a0dd09ec2c3c7df9f6975ea0",
          "discovery_splash": null,
          "approximate_member_count": 2,
          "approximate_presence_count": 2,
          "features": [
            "INVITE_SPLASH",
            "VANITY_URL",
            "COMMERCE",
            "BANNER",
            "NEWS",
            "VERIFIED",
            "VIP_REGIONS"
          ],
          "emojis": [
            {
              "name": "ultrafastparrot",
              "roles": [],
              "id": "393564762228785161",
              "require_colons": true,
              "managed": false,
              "animated": true,
              "available": true
            }
          ],
          "banner": "5c3cb8d1bc159937fffe7e641ec96ca7",
          "owner_id": "53908232506183680",
          "application_id": null,
          "region": null,
          "afk_channel_id": null,
          "afk_timeout": 300,
          "system_channel_id": null,
          "widget_enabled": true,
          "widget_channel_id": "639513352485470208",
          "verification_level": 0,
          "roles": [
            {
              "id": "2909267986263572999",
              "name": "@everyone",
              "permissions": "49794752",
              "position": 0,
              "color": 0,
              "hoist": false,
              "managed": false,
              "mentionable": false
            }
          ],
          "default_message_notifications": 1,
          "mfa_level": 0,
          "explicit_content_filter": 0,
          "max_presences": null,
          "max_members": 250000,
          "max_video_channel_users": 25,
          "vanity_url_code": "no",
          "premium_tier": 0,
          "premium_subscription_count": 0,
          "system_channel_flags": 0,
          "preferred_locale": "en-US",
          "rules_channel_id": null,
          "public_updates_channel_id": null
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let guild = try jsonDecoder.decode(Guild.self, from: exampleResponse)

        XCTAssertEqual(guild.id, 2909267986263572999)

        XCTAssertNotEqual(guild.isUnavailable, true)

        XCTAssertEqual(guild.name, "Mason's Test Server")
        XCTAssertEqual(guild.icon, "389030ec9db118cb5b85a732333b7c98")
        XCTAssertEqual(guild.splash, "75610b05a0dd09ec2c3c7df9f6975ea0")
        XCTAssertEqual(guild.discoverySplash, nil)

        XCTAssertEqual(guild.isOwner, nil)
        XCTAssertEqual(guild.ownerID, 53908232506183680)

        XCTAssertEqual(guild.permissions, nil)

        XCTAssertEqual(guild.afkChannelID, nil)
        XCTAssertEqual(guild.afkTimeout, 300)

        XCTAssertEqual(guild.isWidgetEnabled, true)
        XCTAssertEqual(guild.widgetChannelID, 639513352485470208)

        XCTAssertEqual(guild.verificationLevel, .value(.none))

        XCTAssertEqual(guild.defaultMessageNotifications, .value(.onlyMentions))

        XCTAssertEqual(guild.explicitContentFilter, .value(.disabled))

        XCTAssertEqual(guild.roles?.count, 1)
        XCTAssertEqual(guild.roles?[0].id, 2909267986263572999)
        XCTAssertEqual(guild.roles?[0].name, "@everyone")
        XCTAssertEqual(
            guild.roles?[0].permissions,
            [.addReactions,
             .viewAuditLog,
             .stream,
             .viewChannel,
             .sendMessages,
             .embedLinks,
             .attachFiles,
             .readMessageHistory,
             .mentionEveryone,
             .useExternalEmojis,
             .connect,
             .speak,
             .muteMembers,
             .deafenMembers,
             .useVAD])
        XCTAssertEqual(guild.roles?[0].position, 0)
        XCTAssertEqual(guild.roles?[0].color, 0)
        XCTAssertEqual(guild.roles?[0].hoist, false)
        XCTAssertEqual(guild.roles?[0].isManaged, false)
        XCTAssertEqual(guild.roles?[0].isMentionable, false)
        XCTAssertEqual(guild.emojis?.count, 1)
        XCTAssertEqual(guild.emojis?[0].id, 393564762228785161)
        XCTAssertEqual(guild.features?.count, 7)

        XCTAssertEqual(guild.mfaLevel, .value(.none))

        XCTAssertEqual(guild.applicationID, nil)

        XCTAssertEqual(guild.systemChannelID, nil)
        XCTAssertEqual(guild.systemChannelFlags, [])

        XCTAssertEqual(guild.rulesChannelID, nil)

        XCTAssertEqual(guild.maxPresences, nil)
        XCTAssertEqual(guild.maxMembers, 250000)

        XCTAssertEqual(guild.vanityURLCode, "no")
        XCTAssertEqual(guild.description, nil)
        XCTAssertEqual(guild.banner, "5c3cb8d1bc159937fffe7e641ec96ca7")

        XCTAssertEqual(guild.premiumTier, .value(.none))
        XCTAssertEqual(guild.premiumSubscriptionCount, 0)

        XCTAssertEqual(guild.preferredLocale, "en-US")

        XCTAssertEqual(guild.publicUpdatesChannelID, nil)

        XCTAssertEqual(guild.maxVideoChannelUsers, 25)

        XCTAssertEqual(guild.approximateMemberCount, 2)
        XCTAssertEqual(guild.approximatePresenceCount, 2)

        XCTAssertEqual(guild.welcomeScreen, nil)

        XCTAssertEqual(guild.nsfwLevel, nil)

        XCTAssertEqual(guild.stickers, nil)

        XCTAssertEqual(guild.isPremiumProgressBarEnabled, nil)
    }
}
