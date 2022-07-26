// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-discord",
    platforms: [
         .macOS(.v10_15),
         .macCatalyst(.v13),
         .iOS(.v13),
         .tvOS(.v13),
         .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Discord",
            targets: ["Discord"]),
        .library(
            name: "DiscordREST",
            targets: ["DiscordREST"]),
        .library(
            name: "DiscordGateway",
            targets: ["DiscordGateway"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.40.0")),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", .upToNextMajor(from: "2.20.2")),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", .upToNextMajor(from: "1.13.0")),
        .package(url: "https://github.com/sinoru/swift-snowflake", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Discord",
            dependencies: ["DiscordREST", "DiscordGateway"]),
        .target(
            name: "DiscordCore",
            dependencies: [
                .product(name: "Snowflake", package: "swift-snowflake")
            ]),
        .target(
            name: "DiscordREST",
            dependencies: ["DiscordRESTModel"]),
        .target(
            name: "DiscordRESTModel",
            dependencies: [
                "DiscordCore"
            ]),
        .target(
            name: "DiscordGateway",
            dependencies: [
                "DiscordCore",
                "WebSocket",
            ]),
        .target(
            name: "_DiscordTestSupport",
            dependencies: ["Discord"]),
        .target(
            name: "WebSocket",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOWebSocket", package: "swift-nio"),
                .product(
                    name: "NIOTransportServices",
                    package: "swift-nio-transport-services",
                    condition: .when(platforms: [.iOS, .macOS, .tvOS, .watchOS, .macCatalyst])),
                .product(
                    name: "NIOSSL",
                    package: "swift-nio-ssl",
                    condition: .when(platforms: [.android, .linux, .windows])),
            ]),
        .testTarget(
            name: "DiscordRESTTests",
            dependencies: ["DiscordREST", "_DiscordTestSupport"]),
        .testTarget(
            name: "DiscordRESTModelTests",
            dependencies: ["DiscordRESTModel", "_DiscordTestSupport"]),
        .testTarget(
            name: "DiscordGatewayTests",
            dependencies: ["DiscordGateway", "_DiscordTestSupport"]),
    ]
)
