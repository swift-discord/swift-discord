//
//  Foundation+JSONDecoder.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation

extension JSONDecoder {
    static var oAuth2: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return jsonDecoder
    }
}
