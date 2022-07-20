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
        case codeNotFound
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

        authorizeURLComponents.queryItems = [
            URLQueryItem(name: "response_type", value: responseType.rawValue),
            URLQueryItem(name: "client_id", value: configuration.oAuth2ClientID),
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
            URLQueryItem(name: "client_id", value: configuration.oAuth2ClientID),
            URLQueryItem(name: "client_secret", value: configuration.oAuth2ClientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURLComponents?.string),
        ]

        tokenURLRequest.httpMethod = "POST"
        tokenURLRequest.httpBody = tokenRequestURLComponents.percentEncodedQuery?.data(using: .utf8)

        let (data, _) = try await data(for: tokenURLRequest, includesOAuth2Credential: false)

        try updateOAuth2Credential(JSONDecoder.oAuth2.decode(OAuth2Credential.self, from: data))
    }
}
