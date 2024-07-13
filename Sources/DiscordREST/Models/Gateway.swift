//
//  Gateway.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import Foundation

public struct Gateway: Hashable, Sendable {

    public var url: URL
}

extension Gateway: Codable {

    private enum CodingKeys: String, CodingKey {

        case url
    }
}
