//
//  OAuth2CredentialDecodingTests.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import _DiscordTestSupport
@testable import DiscordCore
@testable import DiscordRESTModel

final class OAuth2CredentialDecodingTests: TestCase {
    func testDecodeAccessTokenResponse() throws {
        let accessTokenResponse = """
        {
          "access_token": "6qrZcUqja7812RVdnEKjpzOL4CvHBFG",
          "token_type": "Bearer",
          "expires_in": 604800,
          "refresh_token": "D43f5y0ahjqew82jZ4NViEr2YafMKhue",
          "scope": "identify"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let oAuth2Credential = try jsonDecoder.decode(OAuth2Credential.self, from: accessTokenResponse)

        XCTAssertEqual(oAuth2Credential.tokenType, "Bearer")
        XCTAssertEqual(oAuth2Credential.accessToken, "6qrZcUqja7812RVdnEKjpzOL4CvHBFG")
        XCTAssertEqual(oAuth2Credential.validityPeriod.duration, 604800)
        XCTAssertEqual(oAuth2Credential.refreshToken, "D43f5y0ahjqew82jZ4NViEr2YafMKhue")
        XCTAssertEqual(oAuth2Credential.scopes, OAuth2Credential.Scopes(["identify"]))
    }

    func testDecodeClientCredentialsAccessTokenResponse() throws {
        let clientCredentialsAccessTokenResponse = """
        {
          "access_token": "6qrZcUqja7812RVdnEKjpzOL4CvHBFG",
          "token_type": "Bearer",
          "expires_in": 604800,
          "scope": "identify connections"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let oAuth2Credential = try jsonDecoder.decode(OAuth2Credential.self, from: clientCredentialsAccessTokenResponse)

        XCTAssertEqual(oAuth2Credential.tokenType, "Bearer")
        XCTAssertEqual(oAuth2Credential.accessToken, "6qrZcUqja7812RVdnEKjpzOL4CvHBFG")
        XCTAssertEqual(oAuth2Credential.validityPeriod.duration, 604800)
        XCTAssertEqual(oAuth2Credential.refreshToken, nil)
        XCTAssertEqual(oAuth2Credential.scopes, OAuth2Credential.Scopes(["identify", "connections"]))
    }

    func testDecodeExtendedBotAuthorizationAccessTokenResponse() throws {
        let extendedBotAuthorizationAccessTokenResponse = """
        {
          "token_type": "Bearer",
          "guild": {
            "mfa_level": 0,
            "emojis": [],
            "application_id": null,
            "name": "SomeTest",
            "roles": [
              {
                "hoist": false,
                "name": "@everyone",
                "mentionable": false,
                "color": 0,
                "position": 0,
                "id": "290926798626357250",
                "managed": false,
                "permissions": 49794241,
                "permissions_new": "49794241"
              }
            ],
            "afk_timeout": 300,
            "system_channel_id": null,
            "widget_channel_id": null,
            "region": "us-east",
            "default_message_notifications": 1,
            "explicit_content_filter": 0,
            "splash": null,
            "features": [],
            "afk_channel_id": null,
            "widget_enabled": false,
            "verification_level": 0,
            "owner_id": "53908232999183680",
            "id": "2909267986347357250",
            "icon": null,
            "description": null,
            "public_updates_channel_id": null,
            "rules_channel_id": null,
            "max_members": 100000,
            "vanity_url_code": null,
            "premium_subscription_count": 0,
            "premium_tier": 0,
            "preferred_locale": "en-US",
            "system_channel_flags": 0,
            "banner": null,
            "max_presences": null,
            "discovery_splash": null,
            "max_video_channel_users": 25
          },
          "access_token": "zMndOe7jFLXGawdlxMOdNvXjjOce5X",
          "scope": "bot",
          "expires_in": 604800,
          "refresh_token": "mgp8qnvBwJcmadwgCYKyYD5CAzGAX4"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let oAuth2Credential = try jsonDecoder.decode(OAuth2Credential.self, from: extendedBotAuthorizationAccessTokenResponse)

        XCTAssertEqual(oAuth2Credential.tokenType, "Bearer")
        XCTAssertEqual(oAuth2Credential.accessToken, "zMndOe7jFLXGawdlxMOdNvXjjOce5X")
        XCTAssertEqual(oAuth2Credential.validityPeriod.duration, 604800)
        XCTAssertEqual(oAuth2Credential.refreshToken, "mgp8qnvBwJcmadwgCYKyYD5CAzGAX4")
        XCTAssertEqual(oAuth2Credential.scopes, OAuth2Credential.Scopes(["bot"]))
    }

    func testDecodeWebhookTokenResponse() throws {
        let webhookTokenResponse = """
        {
          "token_type": "Bearer",
          "access_token": "GNaVzEtATqdh173tNHEXY9ZYAuhiYxvy",
          "scope": "webhook.incoming",
          "expires_in": 604800,
          "refresh_token": "PvPL7ELyMDc1836457XCDh1Y8jPbRm",
          "webhook": {
            "application_id": "310954232226357250",
            "name": "testwebhook",
            "url": "https://discord.com/api/webhooks/347114750880120863/kKDdjXa1g9tKNs0-_yOwLyALC9gydEWP6gr9sHabuK1vuofjhQDDnlOclJeRIvYK-pj_",
            "channel_id": "345626669224982402",
            "token": "kKDdjXa1g9tKNs0-_yOwLyALC9gydEWP6gr9sHabuK1vuofjhQDDnlOclJeRIvYK-pj_",
            "type": 1,
            "avatar": null,
            "guild_id": "290926792226357250",
            "id": "347114750880120863"
          }
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let oAuth2Credential = try jsonDecoder.decode(OAuth2Credential.self, from: webhookTokenResponse)

        XCTAssertEqual(oAuth2Credential.tokenType, "Bearer")
        XCTAssertEqual(oAuth2Credential.accessToken, "GNaVzEtATqdh173tNHEXY9ZYAuhiYxvy")
        XCTAssertEqual(oAuth2Credential.validityPeriod.duration, 604800)
        XCTAssertEqual(oAuth2Credential.refreshToken, "PvPL7ELyMDc1836457XCDh1Y8jPbRm")
        XCTAssertEqual(oAuth2Credential.scopes, OAuth2Credential.Scopes(["webhook.incoming"]))
    }

    func testDecodeAndEncode() throws {
        let accessTokenResponse = """
        {
          "access_token": "6qrZcUqja7812RVdnEKjpzOL4CvHBFG",
          "token_type": "Bearer",
          "expires_in": 604800,
          "refresh_token": "D43f5y0ahjqew82jZ4NViEr2YafMKhue",
          "scope": "identify"
        }
        """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder.discord

        let oAuth2Credential = try jsonDecoder.decode(OAuth2Credential.self, from: accessTokenResponse)

        let encodedOAuth2Credential = try JSONEncoder.discord.encode(oAuth2Credential)

        let oAuth2Credential2 = try jsonDecoder.decode(OAuth2Credential.self, from: encodedOAuth2Credential)

        XCTAssertEqual(oAuth2Credential.tokenType, oAuth2Credential2.tokenType)
        XCTAssertEqual(oAuth2Credential.accessToken, oAuth2Credential2.accessToken)
        XCTAssertEqual(oAuth2Credential.validityPeriod.duration, oAuth2Credential2.validityPeriod.duration)
        XCTAssertEqual(oAuth2Credential.refreshToken, oAuth2Credential2.refreshToken)
        XCTAssertEqual(oAuth2Credential.scopes, oAuth2Credential2.scopes)
    }
}
