//
//  HTTPInitialRequestHandler.swift
//  
//
//  Created by Jaehong Kang on 2022/07/21.
//

import Foundation
import Algorithms
import NIOCore
import NIOHTTP1

class HTTPInitialRequestHandler {
    let host: String?
    let uri: String

    init(host: String?, uri: String = "/") {
        self.host = host
        self.uri = uri
    }

    init(url: URL) {
        self.host = url.host.flatMap {
            [$0, url.port.flatMap { String($0) } ].compacted().joined(separator: ":")
        }

        var uriComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        uriComponents?.scheme = nil
        uriComponents?.host = nil

        self.uri = uriComponents?.string ?? url.path
    }
}

extension HTTPInitialRequestHandler: ChannelInboundHandler, RemovableChannelHandler {
    public typealias InboundIn = HTTPClientResponsePart
    public typealias OutboundOut = HTTPClientRequestPart

    func channelActive(context: ChannelHandlerContext) {
        print("Client connected to \(context.remoteAddress!)")

        // We are connected. It's time to send the message to the server to initialize the upgrade dance.
        var headers = HTTPHeaders()
        if let host = host {
            headers.add(name: "Host", value: host)
        }
        headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
        headers.add(name: "Content-Length", value: "\(0)")

        let requestHead = HTTPRequestHead(
            version: .http1_1,
            method: .GET,
            uri: uri,
            headers: headers
        )

        context.write(self.wrapOutboundOut(.head(requestHead)), promise: nil)

        let body = HTTPClientRequestPart.body(.byteBuffer(ByteBuffer()))
        context.write(self.wrapOutboundOut(body), promise: nil)

        context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
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

    func handlerRemoved(context: ChannelHandlerContext) {
        print("HTTP handler removed.")
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("error: ", error)

        // As we are not really interested getting notified on success or failure
        // we just pass nil as promise to reduce allocations.
        context.close(promise: nil)
    }
}
