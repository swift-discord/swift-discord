//
//  Permission+CodingStrategies.swift
//  
//
//  Created by Mina Her on 2022/07/30.
//

public enum PermissionDecodingStrategy: Sendable {

    case uint64

    case string

    @preconcurrency
    case custom(@Sendable (Decoder) throws -> Permission)
}

extension PermissionDecodingStrategy {

    fileprivate static let `default`: Self = .string
}

public enum PermissionEncodingStrategy: Sendable {

    case uint64

    case string

    @preconcurrency
    case custom(@Sendable (Permission, Encoder) throws -> Void)
}

extension PermissionEncodingStrategy {

    fileprivate static let `default`: Self = .string
}

// MARK: -

extension CodingUserInfoKey {

    fileprivate static let permissionDecodingStrategyKey: Self =
        .init(rawValue: .init(reflecting: PermissionDecodingStrategy.self))!

    fileprivate static let permissionEncodingStrategyKey: Self =
        .init(rawValue: .init(reflecting: PermissionEncodingStrategy.self))!
}

extension Decoder {

    public var permissionDecodingStrategy: PermissionDecodingStrategy {
        userInfo[.permissionDecodingStrategyKey] as? PermissionDecodingStrategy ?? .default
    }
}

extension Encoder {

    public var permissionEncodingStrategy: PermissionEncodingStrategy {
        userInfo[.permissionEncodingStrategyKey] as? PermissionEncodingStrategy ?? .default
    }
}
