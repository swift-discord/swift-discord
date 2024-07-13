# swift-discord

| **main** | **develop** |
|:---:|:---:|
| [![Test](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml) | [![Test](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml/badge.svg?branch=develop)](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml) |

A Swift library for Discord API.

## Package Products

* [`Discord`](https://swift-discord.github.io/swift-discord/documentation/discord/), alias library that contains `DiscordREST`, `DiscordGateway`.
* [`DiscordREST`](https://swift-discord.github.io/swift-discord/documentation/discordrest/), library that can communicate with Discord's REST API. (Requires Foundation framework)
* [`DiscordGateway`](https://swift-discord.github.io/swift-discord/documentation/discordgateway/), library that can communicate with Discord's Gateway API. (Requires SwiftNIO, Foundation framework)

## Available APIs

- [/users/@me](Sources/DiscordREST/User+API.swift#L15-L24)
- [/users/{user.id}](Sources/DiscordREST/User+API.swift#L28-L35)
- [/users/@me/guilds](Sources/DiscordREST/Guild+API.swift#L15-L24)
- [/guilds/{guild.id}](Sources/DiscordREST/Guild+API.swift#L28-L35)
- [/channels/{channel.id}](Sources/DiscordREST/Channel+API.swift#L15-L22)
- [/guilds/{guild.id}/channels](Sources/DiscordREST/Channel+API.swift#L26-L35)

## Supported Platforms

swift-discord aims to support all of the platforms where Swift is supported. Currently, it is developed and tested on macOS and Linux, and is known to support the following operating system versions:

* Ubuntu 18.04+
* macOS 10.15+, iOS 13+, tvOS 13+ or watchOS 6+

## Using **swift-discord** in your project

To use this package in a SwiftPM project, you need to set it up as a package dependency:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      url: "https://github.com/swift-discord/swift-discord.git", 
      .upToNextMajor(from: "0.0.3") // or `.upToNextMinor
    )
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "Discord", package: "swift-discord")
      ]
    )
  ]
)
```
