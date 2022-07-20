//
//  Foundation+JSONEncoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import Snowflake

extension JSONEncoder {
    static var oAuth2: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        return jsonEncoder
    }

    public static var discord: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.snowflakeEncodingStrategy = .string

        return jsonEncoder
    }
}
