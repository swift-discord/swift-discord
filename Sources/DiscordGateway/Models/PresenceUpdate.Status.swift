//
//  PresenceUpdate.Status.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

extension PresenceUpdate {

    public struct Status: Codable, Hashable, RawRepresentable, Sendable {

        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension PresenceUpdate.Status {

    public static let online: Self = .init("online")

    public static let dnd: Self = .init("dnd")

    public static let idle: Self = .init("idle")

    public static let invisible: Self = .init("invisible")

    public static let offline: Self = .init("offline")

    private init(_ stringValue: String) {
        rawValue = stringValue
    }
}

extension PresenceUpdate.Status: Equatable {

    public static func == (lhs: Self, rhs: String) -> Bool {
        lhs.rawValue == rhs
    }

    public static func == (lhs: String, rhs: Self) -> Bool {
        lhs == rhs.rawValue
    }
}
