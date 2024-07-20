//
//  GatewaySession+EventHandler.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension GatewaySession {
    public class EventHandler: Identifiable {
        private(set) var eventHandler: (@Sendable (GatewayDynamicPayload) async -> Void)?

        init(eventHandler: @escaping @Sendable (GatewayDynamicPayload) async -> Void) {
            self.eventHandler = eventHandler
        }

        public func invalidate() {
            eventHandler = nil
        }
    }

    public func handleEvent(_ eventHandler: @escaping @Sendable (GatewayDynamicPayload) async -> Void) async -> EventHandler {
        let eventHandler = EventHandler(eventHandler: eventHandler)

        await actor.run { actor in
            actor.eventHandlers.remove(.init(nil))
            actor.eventHandlers.insert(.init(eventHandler))
        }

        return eventHandler
    }

    @inlinable
    public func handleEvent(_ eventHandler: @escaping @Sendable (GatewayDynamicPayload) -> Void) async -> EventHandler {
        return await self.handleEvent { (payload) async in
            eventHandler(payload)
        }
    }
}

extension GatewaySession.EventHandler: Equatable {
    public static func == (lhs: GatewaySession.EventHandler, rhs: GatewaySession.EventHandler) -> Bool {
        lhs.id == rhs.id
    }
}

extension GatewaySession.EventHandler: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
