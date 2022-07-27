//
//  RESTError.swift
//  
//
//  Created by Mina Her on 2022/07/27.
//

import protocol Foundation.LocalizedError

public struct RESTError: Hashable, Sendable {

    public let code: Code

    public let errors: [Error]

    public let message: String
}

extension RESTError {

    public enum Code: Hashable, Sendable {

        case intValue(Int)

        case stringValue(String)
    }

    public enum Error: Hashable, Sendable {

        case underlyingErrors([RESTError])

        case keyedUnderlyingErrors(key: String, [RESTError])

        case errors(errors: [Error])

        case keyedErrors(key: String, errors: [Error])
    }
}

extension RESTError: CustomStringConvertible {

    public var description: String {
        "<\(Self.self): \(message.debugDescription) (\(code.description)) \(errors.description)>"
    }
}

extension RESTError: Decodable {

    private enum CodingKeys: String, CodingKey {

        case code

        case errors

        case message
    }

    fileprivate static func errors(container: KeyedDecodingContainer<Error.CodingKeys>) throws -> [Error] {
        var result = [Error]()
        if let error = try? Error.underlyingErrors(container: container) {
            result.append(error)
        } else {
            let keys = container.allKeys
            let intKeys = keys.compactMap({$0.intValue ?? Int($0.stringValue)})
            if intKeys.isEmpty {
                for key in keys {
                    if let error = try? Error.keyedUnderlyingErrors(key: key, container: container) {
                        result.append(error)
                    } else if let error = try Error.keyedErrors(key: key, container: container) {
                        result.append(error)
                    }
                }
            } else {
                for key in keys {
                    let container = try container.nestedContainer(keyedBy: Error.CodingKeys.self, forKey: key)
                    if let error = try? Error.underlyingErrors(container: container) {
                        result.append(error)
                    } else {
                        result.append(.errors(errors: try Self.errors(container: container)))
                    }
                }
            }
        }
        return result
    }

    public init(from decoder: Decoder) throws {
        try self.init(from: try decoder.container(keyedBy: CodingKeys.self))
    }

    private init(from container: KeyedDecodingContainer<CodingKeys>) throws {
        code = try container.decode(Code.self, forKey: .code)
        if container.contains(.errors) {
            self.errors =
                try Self.errors(
                    container: try container.nestedContainer(
                        keyedBy: Error.CodingKeys.self,
                        forKey: .errors))
        } else {
            self.errors = []
        }
        message = try container.decode(String.self, forKey: .message)
    }
}

extension RESTError: LocalizedError {

    public var errorDescription: String? {
        message
    }
}

extension RESTError.Code: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
        } else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: container.codingPath,
                    debugDescription: "Expected to decode Int or String but found other instead."))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intValue(let intValue):
            try container.encode(intValue)
        case .stringValue(let stringValue):
            try container.encode(stringValue)
        }
    }
}

extension RESTError.Code: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .intValue(let intValue):
            return intValue.description
        case .stringValue(let stringValue):
            return stringValue.debugDescription
        }
    }
}

extension RESTError.Code: CustomStringConvertible {

    public var description: String {
        switch self {
        case .intValue(let intValue):
            return intValue.description
        case .stringValue(let stringValue):
            return stringValue
        }
    }
}

extension RESTError.Code: Equatable {

    public static func == (lhs: Self, rhs: Int) -> Bool {
        if case .intValue(let lhs) = lhs {
            return lhs == rhs
        }
        return false
    }

    public static func == (lhs: Self, rhs: String) -> Bool {
        if case .stringValue(let lhs) = lhs {
            return lhs == rhs
        }
        return false
    }

    public static func == (lhs: Int, rhs: Self) -> Bool {
        if case .intValue(let rhs) = rhs {
            return lhs == rhs
        }
        return false
    }

    public static func == (lhs: String, rhs: Self) -> Bool {
        if case .stringValue(let rhs) = rhs {
            return lhs == rhs
        }
        return false
    }
}

extension RESTError.Error {

    fileprivate struct CodingKeys: CodingKey {

        fileprivate static let _errors = Self.init("_errors")

        fileprivate let intValue: Int?

        fileprivate let stringValue: String

        fileprivate init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "Index \(intValue)"
        }

        fileprivate init?(stringValue: String) {
            intValue = nil
            self.stringValue = stringValue
        }

        fileprivate init(_ stringValue: String) {
            self.init(stringValue: stringValue)!
        }
    }

    fileprivate static func underlyingErrors(container: KeyedDecodingContainer<CodingKeys>) throws -> Self? {
        guard container.contains(CodingKeys._errors)
        else {
            return nil
        }
        if let _ = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: CodingKeys._errors) {
            return nil
        }
        guard var container = try? container.nestedUnkeyedContainer(forKey: CodingKeys._errors)
        else {
            return nil
        }
        var underlyingErrors = [RESTError]()
        while !container.isAtEnd {
            do {
                let container = try container.nestedContainer(keyedBy: RESTError.CodingKeys.self)
                underlyingErrors.append(try .init(from: container))
            } catch {
                dump(error)
                fatalError()
            }
        }
        return .underlyingErrors(underlyingErrors)
    }

    fileprivate static func keyedUnderlyingErrors(key: CodingKeys, container: KeyedDecodingContainer<CodingKeys>) throws -> Self? {
        let container = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
        guard
            let error = try? underlyingErrors(container: container),
            case .underlyingErrors(let underlyingErrors) = error
        else {
            return nil
        }
        return .keyedUnderlyingErrors(key: key.stringValue, underlyingErrors)
    }

    fileprivate static func keyedErrors(key: CodingKeys, container: KeyedDecodingContainer<CodingKeys>) throws -> Self? {
        let container = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
        guard let errors = try? RESTError.errors(container: container)
        else {
            return nil
        }
        return .keyedErrors(key: key.stringValue, errors: errors)
    }
}

extension RESTError.Error: CustomStringConvertible {

    public var description: String {
        switch self {
        case .underlyingErrors(let errors):
            return errors.description
        case .keyedUnderlyingErrors(key: let key, let errors):
            return "\(key): \(errors.description)"
        case .errors(errors: let errors):
            return errors.description
        case .keyedErrors(key: let key, errors: let errors):
            return "\(key): \(errors.description)"
        }
    }
}
