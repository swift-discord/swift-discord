//
//  Foundation+URLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    @inlinable
    func _data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, macOS 13.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *) {
            return try await data(for: request, delegate: delegate)
        } else {
            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
                dataTask(with: request) { data, response, error in
                    guard
                        let data = data,
                        let response = response
                    else {
                        continuation.resume(throwing: error!)
                        return
                    }

                    continuation.resume(returning: (data, response))
                }.resume()
            }
        }
    }
}
