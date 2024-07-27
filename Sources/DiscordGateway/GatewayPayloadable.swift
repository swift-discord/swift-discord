//
//  GatewayPayloadable.swift
//
//
//  Created by Jaehong Kang on 7/27/24.
//

public protocol GatewayPayloadable<Opcode, Data> {
    associatedtype Opcode: RawRepresentable where Opcode.RawValue: BinaryInteger
    associatedtype Data

    var opcode: Opcode { get }
    var data: Data { get }
}
