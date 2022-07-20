# swift-discord

[![Test](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml/badge.svg)](https://github.com/swift-discord/swift-discord/actions/workflows/test.yml)

A Swift library for Discord API.

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
      .upToNextMajor(from: "0.0.1") // or `.upToNextMinor
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
