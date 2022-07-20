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
    @available(iOS, deprecated: 15.0, renamed: "data(for:delegate:)")
    @available(macOS, deprecated: 13.0, renamed: "data(for:delegate:)")
    @available(macCatalyst, deprecated: 15.0, renamed: "data(for:delegate:)")
    @available(tvOS, deprecated: 15.0, renamed: "data(for:delegate:)")
    @available(watchOS, deprecated: 8.0, renamed: "data(for:delegate:)")
    @inline(__always)
    func _data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
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
}
