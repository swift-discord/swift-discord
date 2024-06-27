//
//  PresenceUpdate.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

import struct Foundation.Date

public struct PresenceUpdate: Hashable, Sendable {

    public var sinceDate: Date?

    public var activities: [Activity]

    public var status: Status

    public var afk: Bool

    public init(
        sinceDate: Date? = nil,
        activities: [Activity],
        status: Status,
        afk: Bool
    ) {
        self.sinceDate = sinceDate
        self.activities = activities
        self.status = status
        self.afk = afk
    }
}

extension PresenceUpdate: Codable {

    private enum CodingKeys: String, CodingKey {

        case sinceDate = "since"

        case activities

        case status

        case afk
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if !(try container.decodeNil(forKey: .sinceDate)) {
            sinceDate = .init(timeIntervalSince1970: .init(try container.decode(Int64.self, forKey: .sinceDate)) / 1000)
        }
        activities = try container.decode([Activity].self, forKey: .activities)
        status = try container.decode(Status.self, forKey: .status)
        afk = try container.decode(Bool.self, forKey: .afk)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let sinceDate = sinceDate {
            try container.encode(sinceDate.timeIntervalSince1970 * 1000, forKey: .sinceDate)
        }
        else {
            try container.encodeNil(forKey: .sinceDate)
        }
        try container.encode(activities, forKey: .activities)
        try container.encode(status, forKey: .status)
        try container.encode(afk, forKey: .afk)
    }
}
