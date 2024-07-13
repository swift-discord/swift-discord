//
//  Actor.swift
//
//
//  Created by Jaehong Kang on 6/28/24.
//

extension Actor {
    public func run<T>(resultType: T.Type = T.self, body: (isolated Self) throws -> T) async rethrows -> T where T : Sendable {
        try body(self)
    }

    public func run<T>(resultType: T.Type = T.self, body: (isolated Self) async throws -> T) async rethrows -> T where T : Sendable {
        try await body(self)
    }
}
