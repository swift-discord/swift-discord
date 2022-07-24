//
//  Session+OAuth2.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Session {
    public enum OAuth2AuthorizationResponseType: String {
        case code
        case token
    }

    public enum OAuth2AuthorizationPrompt: String {
        case consent
        case none
    }

    public enum OAuth2AuthorizeError: Error {
        case unknown
        case clientIDNotFound
        case clientSecretNotFound
        case codeNotFound
        case refreshTokenNotFound
        case stateMismatch
    }

    public func oAuth2AuthorizeURL(
        responseType: OAuth2AuthorizationResponseType = .code,
        scopes: OAuth2Credential.Scopes,
        state: String? = nil,
        callbackURL: URL,
        prompt: OAuth2AuthorizationPrompt = .consent
    ) throws -> URL {
        guard var authorizeURLComponents = URL(discordAPIPath: "oauth2/authorize").flatMap({ URLComponents(url: $0, resolvingAgainstBaseURL: true) }) else {
            throw OAuth2AuthorizeError.unknown
        }

        guard let oAuth2ClientID = configuration.oAuth2ClientID else {
            throw OAuth2AuthorizeError.clientIDNotFound
        }

        authorizeURLComponents.queryItems = [
            URLQueryItem(name: "response_type", value: responseType.rawValue),
            URLQueryItem(name: "client_id", value: oAuth2ClientID),
            URLQueryItem(name: "scope", value: scopes.joined(separator: " ")),
            state.flatMap { URLQueryItem(name: "state", value: $0) },
            URLQueryItem(name: "redirect_uri", value: callbackURL.absoluteString),
            URLQueryItem(name: "prompt", value: prompt.rawValue)
        ].compactMap({$0})

        guard let authorizeURL = authorizeURLComponents.url else {
            throw OAuth2AuthorizeError.unknown
        }

        return authorizeURL
    }

    public func updateOAuth2Credential(authorizeCallbackURL: URL, state: String? = nil) async throws {
        guard let oAuth2ClientID = configuration.oAuth2ClientID else {
            throw OAuth2AuthorizeError.clientIDNotFound
        }

        guard let oAuth2ClientSecret = configuration.oAuth2ClientSecret else {
            throw OAuth2AuthorizeError.clientSecretNotFound
        }

        let callbackURLComponents = URLComponents(url: authorizeCallbackURL, resolvingAgainstBaseURL: true)

        let callbackURLQueryItems: [String: String?]? = callbackURLComponents?.queryItems.flatMap {
            Dictionary(uniqueKeysWithValues: $0.map { (key: $0.name, value: $0.value) })
        }

        guard let code = callbackURLQueryItems?["code"] else {
            throw OAuth2AuthorizeError.codeNotFound
        }

        let responseState = callbackURLQueryItems?["state"]

        guard state == responseState else {
            throw OAuth2AuthorizeError.stateMismatch
        }

        guard let tokenURL = URL(discordAPIPath: "oauth2/token") else {
            throw OAuth2AuthorizeError.unknown
        }

        var tokenURLRequest = URLRequest(url: tokenURL)

        var tokenRequestURLComponents = URLComponents()

        var redirectURLComponents = callbackURLComponents
        redirectURLComponents?.query = nil

        tokenRequestURLComponents.queryItems = [
            URLQueryItem(name: "client_id", value: oAuth2ClientID),
            URLQueryItem(name: "client_secret", value: oAuth2ClientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURLComponents?.string),
        ]

        tokenURLRequest.httpMethod = "POST"
        tokenURLRequest.httpBody = tokenRequestURLComponents.percentEncodedQuery?.data(using: .utf8)

        let (data, _) = try await data(for: tokenURLRequest, includesOAuth2Credential: false)

        try updateOAuth2Credential(JSONDecoder.discord.decode(OAuth2Credential.self, from: data))
    }

    public func refreshOAuth2Credential() async throws {
        guard let tokenURL = URL(discordAPIPath: "oauth2/token") else {
            throw OAuth2AuthorizeError.unknown
        }

        guard let oAuth2ClientID = configuration.oAuth2ClientID else {
            throw OAuth2AuthorizeError.clientIDNotFound
        }

        guard let oAuth2ClientSecret = configuration.oAuth2ClientSecret else {
            throw OAuth2AuthorizeError.clientSecretNotFound
        }

        guard let refreshToken = oAuth2Credential?.refreshToken else {
            throw OAuth2AuthorizeError.refreshTokenNotFound
        }

        var tokenURLRequest = URLRequest(url: tokenURL)

        var tokenRequestURLComponents = URLComponents()
        tokenRequestURLComponents.queryItems =  [
            URLQueryItem(name: "client_id", value: oAuth2ClientID),
            URLQueryItem(name: "client_secret", value: oAuth2ClientSecret),
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        tokenURLRequest.httpMethod = "POST"
        tokenURLRequest.httpBody = tokenRequestURLComponents.percentEncodedQuery?.data(using: .utf8)

        let (data, _) = try await data(for: tokenURLRequest, includesOAuth2Credential: false)

        try updateOAuth2Credential(JSONDecoder.discord.decode(OAuth2Credential.self, from: data))
    }
}
