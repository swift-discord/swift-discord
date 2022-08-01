//
//  URL+Sendable.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

#if swift(<5.7)
import struct Foundation.URL

extension URL: @unchecked Sendable {
}
#endif
