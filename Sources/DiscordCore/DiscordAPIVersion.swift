//
//  DiscordAPIVersion.swift
//  
//
//  Created by Jaehong Kang on 2022/07/24.
//

public struct DiscordAPIVersion : Encodable {
    let versionString: String

    fileprivate init(versionString: String) {
        self.versionString = versionString
    }

    @available(*, unavailable, message: "DiscordAPI v6 is the oldest deprecated version")
    public static let v3: DiscordAPIVersion = .init(versionString: "3")

    @available(*, unavailable, message: "DiscordAPI v6 is the oldest deprecated version")
    public static let v4: DiscordAPIVersion = .init(versionString: "4")

    @available(*, unavailable, message: "DiscordAPI v6 is the oldest deprecated version")
    public static let v5: DiscordAPIVersion = .init(versionString: "5")

    @available(*, deprecated, message: "DiscordAPI v9 is the oldest available version")
    public static let v6: DiscordAPIVersion = .init(versionString: "6")

    @available(*, deprecated, message: "DiscordAPI v9 is the oldest available version")
    public static let v7: DiscordAPIVersion = .init(versionString: "7")

    @available(*, deprecated, message: "DiscordAPI v9 is the oldest available version")
    public static let v8: DiscordAPIVersion = .init(versionString: "8")

    public static let v9: DiscordAPIVersion = .init(versionString: "9")

    public static let v10: DiscordAPIVersion = .init(versionString: "10")
}
