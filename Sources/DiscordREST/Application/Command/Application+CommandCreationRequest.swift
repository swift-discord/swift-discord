//
//  Application+CommandCreationRequest.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension Application {
    public protocol CommandCreationRequest: Encodable {
        var name: String { get }
        var nameLocalizations: Localizations? { get }
        var type: CommandType { get }
        var defaultMemberPermissions: String? { get }
        @available(*, deprecated, renamed: "contexts")
        var dmPermission: Bool? { get }
        var defaultPermission: Bool? { get }
        var nsfw: Bool? { get }
    }
}
