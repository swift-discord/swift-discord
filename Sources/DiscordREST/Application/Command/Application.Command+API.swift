//
//  Application+CommandAPI.swift
//
//
//  Created by Jaehong Kang on 7/16/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Snowflake
import DiscordCore

extension Application.Command {
    public static func fetchCommands(
        for applicationID: Snowflake,
        session: RESTSession) async throws -> [any Application._Command] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "applications/\(applicationID)/commands", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        return try JSONDecoder.discord.decode([Application.Command].self, from: data)
            .map(\.base)
    }
}

extension Application.Command {
    public static func createCommand(
        _ commandCreationRequest: some Application.CommandCreationRequest,
        for applicationID: Snowflake,
        session: RESTSession
    ) async throws -> (
        isOverwritten: Bool,
        command: Application._Command
    ) {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "applications/\(applicationID)/commands", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder.discord.encode(commandCreationRequest)

        let (data, response) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let isOverwritten: Bool = ((response as? HTTPURLResponse)?.statusCode ?? 0) == 200

        return (
            isOverwritten,
            try JSONDecoder.discord.decode(Application.Command.self, from: data).base
        )
    }
}

extension Application.Command {
    public static func fetchCommands(
        for guildID: Snowflake,
        applicationID: Snowflake,
        session: RESTSession) async throws -> [any Application._Command] {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "applications/\(applicationID)/guilds/\(guildID)/commands", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "GET"

        let (data, _) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        return try JSONDecoder.discord.decode([Application.Command].self, from: data)
            .map(\.base)
    }
}

extension Application.Command {
    public static func createCommand(
        _ commandCreationRequest: some Application.CommandCreationRequest,
        for guildID: Snowflake,
        applicationID: Snowflake,
        session: RESTSession
    ) async throws -> (
        isOverwritten: Bool,
        command: Application._Command
    ) {
        var urlRequest = URLRequest(url: URL(discordAPIPath: "applications/\(applicationID)/guilds/\(guildID)/commands", apiVersion: session.configuration.apiVersion)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder.discord.encode(commandCreationRequest)

        let (data, response) = try await session.data(for: urlRequest, includesOAuth2Credential: true)

        let isOverwritten: Bool = ((response as? HTTPURLResponse)?.statusCode ?? 0) == 200

        return (
            isOverwritten,
            try JSONDecoder.discord.decode(Application.Command.self, from: data).base
        )
    }
}
