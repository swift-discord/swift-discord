//
//  Foundation+JSONDecoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
import Snowflake

extension JSONDecoder {
    static var oAuth2: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }

    public static var discord: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.snowflakeDecodingStrategy = .auto

        return jsonDecoder
    }
}
