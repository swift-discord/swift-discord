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
    public actor ThreadPool {
        let eventLoopGroup: EventLoopGroup

        public init(threadCount: Int = 1) {
            #if canImport(NIOTransportServices)
            self.eventLoopGroup = NIOTSEventLoopGroup(loopCount: threadCount, defaultQoS: .default)
            #else
            self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: threadCount)
            #endif
        }

        deinit {
            Task.detached(priority: .utility) { [eventLoopGroup] in
                try await eventLoopGroup.shutdownGracefully()
            }
        }
    }

    public struct Configuration {
        public var threadPool: ThreadPool

        public init(threadPool: ThreadPool = ThreadPool()) {
            self.threadPool = threadPool
        }
    }
}
