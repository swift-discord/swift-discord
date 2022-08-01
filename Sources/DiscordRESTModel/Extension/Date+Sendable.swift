//
//  Date+Sendable.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

#if swift(<5.7)
import struct Foundation.Date

extension Date: @unchecked Sendable {
}
#endif
