//
//  VoiceSession+IPDiscovery.swift
//
//
//  Created by Jaehong Kang on 8/8/24.
//

import NIOCore
#if canImport(NIOTransportServices)
import NIOTransportServices
import Network
#endif

extension VoiceSession {
    func discoveryExternalPort(host: String, port: Int) async throws {
        let bootstrap = {
            #if canImport(NIOTransportServices)
            NIOTSDatagramBootstrap(group: NIOSingletons.transportServicesEventLoopGroup)
            #else
            DatagramBootstrap(group: NIOSingletons.posixEventLoopGroup)
            #endif
        }()
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)

        let channel = try await bootstrap.connect(host: host, port: port).get()

        let asyncChannel = try await channel.eventLoop.makeCompletedFuture {
            try NIOAsyncChannel<AddressedEnvelope<ByteBuffer>, AddressedEnvelope<ByteBuffer>>(wrappingChannelSynchronously: channel)
        }.get()
    }
}
