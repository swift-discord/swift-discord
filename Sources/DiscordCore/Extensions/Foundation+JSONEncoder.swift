//
//  Foundation+JSONEncoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation

extension JSONEncoder {
    public static var discord: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.snowflakeEncodingStrategy = .string

        return jsonEncoder
    }
}
