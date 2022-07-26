# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.3]
### Added
- Add `DiscordGateway` module

### Changed
- Rename `DiscordV10` module to `DiscordREST`

## [0.0.2]
### Added
- Add `Guild` struct
- Add `Channel` struct
- Add `Role` struct
- Add `Sticket` struct
- Add [`Equatable`](https://developer.apple.com/documentation/swift/equatable), [`Hashable`](https://developer.apple.com/documentation/swift/hashable), [`Identifiable`](https://developer.apple.com/documentation/swift/identifiable) to `User` struct
- Add [`Equatable`](https://developer.apple.com/documentation/swift/equatable), [`Hashable`](https://developer.apple.com/documentation/swift/hashable) to `User.Flags` struct
- Add [`Sendable`](https://developer.apple.com/documentation/swift/sendable) to `Unknown` enum

### Changed
- Rename `JSONDecoder.oAuth2` to `JSONDecoder.discordOAuth2`
- Rename `JSONEncoder.oAuth2` to `JSONEncoder.discordOAuth2`
- Change `User().premiumType` type from `User.PremiumType` to `Unknown<User.PremiumType>`
- Update [`sinoru/swift-snowflake`](https://github.com/sinoru/swift-snowflake/compare/v0.0.1...v0.0.2) from v0.0.1 to v0.0.2

### Removed
- Remove support of Swift 5.5

## [0.0.1]
This is the initial release.

[Unreleased]: https://github.com/swift-discord/swift-discord/compare/v0.0.3...HEAD
[0.0.3]: https://github.com/swift-discord/swift-discord/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/swift-discord/swift-discord/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/swift-discord/swift-discord/releases/tag/v0.0.1
