//
//  HTTPInitialRequestHandler.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Algorithms
import NIOCore
import NIOPosix
import NIOHTTP1
import NIOWebSocket

class HTTPInitialRequestHandler: ChannelInboundHandler, RemovableChannelHandler {
    public typealias InboundIn = HTTPClientResponsePart
    public typealias OutboundOut = HTTPClientRequestPart

    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func channelActive(context: ChannelHandlerContext) {
        print("Client connected to \(context.remoteAddress!)")

        // We are connected. It's time to send the message to the server to initialize the upgrade dance.
        var headers = HTTPHeaders()
        if let host = url.host {
            headers.add(name: "Host", value: "\([host, url.port.flatMap { String($0) } ].compacted().joined(separator: ":"))")
        }
        headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
        headers.add(name: "Content-Length", value: "\(0)")

        let requestHead = HTTPRequestHead(version: .http1_1,
                                          method: .GET,
                                          uri: url.path,
                                          headers: headers)

        context.write(self.wrapOutboundOut(.head(requestHead)), promise: nil)

        let body = HTTPClientRequestPart.body(.byteBuffer(ByteBuffer()))
        context.write(self.wrapOutboundOut(body), promise: nil)

        context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {

        let clientResponse = self.unwrapInboundIn(data)

        print("Upgrade failed")

        switch clientResponse {
        case .head(let responseHead):
            print("Received status: \(responseHead.status)")
        case .body(let byteBuffer):
            let string = String(buffer: byteBuffer)
            print("Received: '\(string)' back from the server.")
        case .end:
            print("Closing channel.")
            context.close(promise: nil)
        }
    }

    public func handlerRemoved(context: ChannelHandlerContext) {
        print("HTTP handler removed.")
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("error: ", error)

        // As we are not really interested getting notified on success or failure
        // we just pass nil as promise to reduce allocations.
        context.close(promise: nil)
    }
}
