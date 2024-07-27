//
//  GatewaySession+Configuration.swift
//
//
//  Created by Jaehong Kang on 7/10/24.
//

import Foundation
import DiscordREST

extension GatewaySession {
    public struct Configuration: Sendable {
        public var apiVersion: DiscordAPIVersion?
        public var encoding: Encoding
        public var osInfo: String = {
            #if os(iOS)
            return "iOS"
            #elseif os(macOS)
            return "macOS"
            #elseif os(watchOS)
            return "watchOS"
            #elseif os(tvOS)
            return "tvOS"
            #elseif os(Linux)
            return "Linux"
            #elseif os(Windows)
            return "Windows"
            #elseif os(Android)
            return "Android"
            #else
            return "Unknown"
            #endif
        }()
        public var browserInfo: String
        public var deviceInfo: String
        public var intents: Intents

        public init(
            apiVersion: DiscordAPIVersion? = nil,
            encoding: Encoding,
            browserInfo: String = "swift-discord",
            deviceInfo: String = "swift-discord",
            intents: Intents = []
        ) {
            self.apiVersion = apiVersion
            self.encoding = encoding
            self.browserInfo = browserInfo
            self.deviceInfo = deviceInfo
            self.intents = intents
        }
    }
}
