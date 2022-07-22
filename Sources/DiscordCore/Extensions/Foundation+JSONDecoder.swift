//
//  Foundation+JSONDecoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/22.
//

import Foundation

extension JSONDecoder {
    public static var discord: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.snowflakeDecodingStrategy = .auto

        return jsonDecoder
    }
}
