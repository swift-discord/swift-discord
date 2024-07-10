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
        public let apiVersion: DiscordAPIVersion?
        
        public let encoding: Encoding

        public init(
            apiVersion: DiscordAPIVersion? = nil,
            encoding: Encoding
        ) {
            self.apiVersion = apiVersion
            self.encoding = encoding
        }
    }
}
