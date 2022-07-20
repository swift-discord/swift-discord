//
//  Session+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Session {
    public struct Configuration {
        public let urlSessionConfiguration: URLSessionConfiguration

        public init(urlSessionConfiguration: URLSessionConfiguration) {
            self.urlSessionConfiguration = urlSessionConfiguration
        }
    }
}
