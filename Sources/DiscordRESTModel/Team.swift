//
//  Team.swift
//  
//
//  Created by Mina Her on 2022/07/30.
//

public struct Team: Hashable, Identifiable, Sendable {

    public var icon: String?

    public var id: Snowflake

    public var members: [Member]

    public var name: String

    public var ownerUserID: Snowflake
}

extension Team {

    public struct Member: Hashable, Sendable {

        public var membershipState: MembershipState

        public var permissions: [String]

        public var teamID: Snowflake

        public var user: User
    }
}

extension Team.Member {

    public enum MembershipState: Int, Hashable, Sendable {

        case invited = 1

        case accepted = 2
    }
}

extension Team: Codable {

    private enum CodingKeys: String, CodingKey {

        case icon

        case id

        case members

        case name

        case ownerUserID = "ownerUserId"
    }
}

extension Team.Member: Codable {

    private enum CodingKeys: String, CodingKey {

        case membershipState

        case permissions

        case teamID = "teamId"

        case user
    }
}

extension Team.Member.MembershipState: Codable {
}
