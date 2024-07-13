//
//  Resume.swift
//  
//
//  Created by Mina Her on 2022/08/02.
//

public struct Resume: Hashable, Sendable {

    public var token: String

    public var sessionID: String

    public var sequence: Int
}

extension Resume: Codable {

    private enum CodingKeys: String, CodingKey {

        case token

        case sessionID = "sessionId"

        case sequence = "seq"
    }
}
