//
//  Session+OAuth2Authentication.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

#if canImport(AuthenticationServices) && !os(tvOS)

import AuthenticationServices

extension Session {
    public func oAuth2Authorize(
        scopes: OAuth2Credential.Scopes,
        state: String = UUID().uuidString,
        callbackURL: URL,
        prompt: OAuth2AuthorizationPrompt = .consent,
        webAuthenticationSessionHandler: (ASWebAuthenticationSession) -> Bool
    ) async throws -> Bool {
        guard
            let callbackURLScheme = callbackURL.scheme
        else {
            throw OAuth2AuthorizeError.unknown
        }

        let url = try oAuth2AuthorizeURL(
            responseType: .code,
            scopes: scopes,
            state: state,
            callbackURL: callbackURL,
            prompt: prompt
        )

        let callbackURL: URL? = try await withCheckedThrowingContinuation { continuation in
            let webAuthenticationSession = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: callbackURLScheme
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: callbackURL)
            }

            guard webAuthenticationSessionHandler(webAuthenticationSession) else {
                continuation.resume(returning: nil)
                return
            }
        }

        guard let callbackURL = callbackURL else {
            return false
        }

        try await self.updateOAuth2Credential(authorizeCallbackURL: callbackURL, state: state)

        return true
    }
}

#endif
