//
//  WebSocketSession+Configuration.swift
//  
//
//  Created by Jaehong Kang on 2022/07/23.
//

import NIOCore
#if canImport(NIOTransportServices)
import NIOTransportServices
#else
import NIOPosix
#endif

extension WebSocketSession {
    public struct Configuration {
        public var eventLoopGroup: EventLoopGroup

        public init(eventLoopGroup: EventLoopGroup = Self.defaultEventLoopGroup) {
            self.eventLoopGroup = eventLoopGroup
        }
    }
}

extension WebSocketSession.Configuration {
    public static var defaultEventLoopGroup: EventLoopGroup {
        #if canImport(NIOTransportServices)
        return NIOTSEventLoopGroup(loopCount: 1, defaultQoS: .default)
        #else
        return MultiThreadedEventLoopGroup(numberOfThreads: 1)
        #endif
    }
}
