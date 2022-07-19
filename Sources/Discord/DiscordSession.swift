//
//  DiscordSession.swift
//  
//
//  Created by Jaehong Kang on 2022/07/19.
//

import Foundation

public actor DiscordSession {
    nonisolated let urlSession: URLSession

    init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
    }
}
