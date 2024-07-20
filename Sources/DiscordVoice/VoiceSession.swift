//
//  VoiceSession.swift
//  
//
//  Created by Jaehong Kang on 7/20/24.
//

import Clibavcodec
import DiscordGateway
import AsyncAlgorithms
import Foundation
import Snowflake

public final class VoiceSession: Sendable {
    public let configuration: Configuration
    public let gatewaySession: GatewaySession

    public init(
        configuration: Configuration,
        gatewaySession: GatewaySession
    ) {
        self.configuration = configuration
        self.gatewaySession = gatewaySession
    }


    public func connect(
        for guildID: Snowflake,
        channelID: Snowflake? = nil,
        mute: Bool,
        deaf: Bool
    ) async throws {
        let events = AsyncChannel<GatewayDynamicPayload>()

        let eventHandler = await gatewaySession.handleEvent { payload in
            await events.send(payload)
        }

        try await gatewaySession.updateVoiceState(
            for: guildID,
            channelID: channelID,
            selfMute: mute,
            selfDeaf: deaf
        )

        for await event in events {
            switch event.opcode {
            case .dispatch where event.type == "VOICE_SERVER_UPDATE":
                let event = try GatewayPayload<VoiceServerUpdate>(event)

                


            default:
                continue
            }
        }

        eventHandler.invalidate()
    }
}
