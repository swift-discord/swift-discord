//
//  HTTPURLResponse+RateLimit.swift
//  
//
//  Created by Mina Her on 2022/07/28.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension HTTPURLResponse {

    internal var rateLimit: RateLimit {
        .init(httpURLResponse: self)
    }
}
