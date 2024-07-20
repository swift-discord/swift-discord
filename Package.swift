// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-discord",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Discord",
            targets: ["Discord"]),
        .library(
            name: "DiscordREST",
            targets: ["DiscordREST"]),
        .library(
            name: "DiscordGateway",
            targets: ["DiscordGateway"]),
        .library(
            name: "DiscordVoice",
            targets: ["DiscordVoice"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sinoru/swift-websocket-client.git", from: "0.1.1"),
        .package(url: "https://github.com/sinoru/swift-snowflake", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .systemLibrary(
            name: "Clibavformat",
            pkgConfig: "libavformat",
            providers: [
                .brew(["ffmpeg"]),
                .apt(["libav-dev"])
            ]
        ),
        .systemLibrary(
            name: "Clibavcodec",
            pkgConfig: "Clibavcodec",
            providers: [
                .brew(["ffmpeg"]),
                .apt(["libavcodec-dev"])
            ]
        ),
        .target(
            name: "Discord",
            dependencies: ["DiscordREST", "DiscordGateway", "DiscordVoice"]),
        .target(
            name: "DiscordCore",
            dependencies: [
                .product(name: "Snowflake", package: "swift-snowflake"),
            ]),
        .target(
            name: "DiscordREST",
            dependencies: ["DiscordCore"]),
        .target(
            name: "DiscordGateway",
            dependencies: [
                .product(name: "WebSocketClientFoundationCompat", package: "swift-websocket-client"),
                "DiscordCore",
                "DiscordREST",
            ]),
        .target(
            name: "DiscordVoice",
            dependencies: [
                .product(name: "WebSocketClientFoundationCompat", package: "swift-websocket-client"),
                "DiscordCore",
                "DiscordGateway",
                "Clibavformat",
                "Clibavcodec",
            ]),
        .target(
            name: "_DiscordTestSupport",
            dependencies: ["DiscordREST"]),
        .testTarget(
            name: "DiscordRESTTests",
            dependencies: ["_DiscordTestSupport", "DiscordCore", "DiscordREST"]),
        .testTarget(
            name: "DiscordGatewayTests",
            dependencies: ["_DiscordTestSupport", "DiscordCore", "DiscordREST", "DiscordGateway"]),
    ]
)
