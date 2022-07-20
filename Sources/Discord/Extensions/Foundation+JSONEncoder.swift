//
//  Foundation+JSONEncoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation

extension JSONEncoder {
    static var oAuth2: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        return jsonEncoder
    }
}
