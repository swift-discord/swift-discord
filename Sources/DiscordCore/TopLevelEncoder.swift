//
//  TopLevelEncoder.swift
//
//
//  Created by Jaehong Kang on 6/28/24.
//

public protocol TopLevelEncoder<Output> {
    /// The type this encoder produces.
    associatedtype Output

    /// Encodes an instance of the indicated type.
    ///
    /// - Parameter value: The instance to encode.
    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}
