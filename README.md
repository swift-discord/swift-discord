# swift-discord

| **main** | **develop** |
|:---:|:---:|
| [![Test](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml) | [![Test](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml/badge.svg?branch=develop)](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml) |

A Swift library for Discord API.

## Available APIs

- [/users/@me](Sources/DiscordAPI/User+API.swift#L15-L24)
- [/users/{user.id}](Sources/DiscordAPI/User+API.swift#L28-L35)
- [/users/@me/guilds](Sources/DiscordAPI/Guild+API.swift#L15-L24)
- [/guilds/{guild.id}](Sources/DiscordAPI/Guild+API.swift#L28-L35)
- [/channels/{channel.id}](Sources/DiscordAPI/Channel+API.swift#L15-L22)
- [/guilds/{guild.id}/channels](Sources/DiscordAPI/Channel+API.swift#L26-L35)

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
      .upToNextMajor(from: "0.0.2") // or `.upToNextMinor
    )
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "DiscordV10", package: "swift-discord")
      ]
    )
  ]
)
```
