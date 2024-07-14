//
//  Foundation+URLSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking

extension URLSession {
    @inline(__always)
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
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
#endif
