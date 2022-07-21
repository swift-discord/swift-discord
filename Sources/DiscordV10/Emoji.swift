//
//  Emoji.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Discord

// TODO: Implement Properties
public struct Emoji: Equatable, Hashable, Sendable, Codable {
    public let id: Snowflake?
    public let name: String?
}
