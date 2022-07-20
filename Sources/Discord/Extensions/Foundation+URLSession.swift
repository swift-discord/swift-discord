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
    func _data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
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

    #if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
    @inlinable
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        _data(for: request, delegate: delegate)
    }
    #endif
}
