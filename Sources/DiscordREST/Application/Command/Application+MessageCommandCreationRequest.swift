//
//  Application+MessageCommandCreationRequest.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension Application {
    public struct MessageCommandCreationRequest: CommandCreationRequest {
        public var name: String
        public var nameLocalizations: Localizations?
        public var type: CommandType { .message }
        public var defaultMemberPermissions: String?
        @available(*, deprecated, renamed: "contexts")
        public var dmPermission: Bool?
        public var defaultPermission: Bool?
        public var nsfw: Bool?
    }
}
