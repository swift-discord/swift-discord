//
//  Session+OAuth2Authentication.swift
//  
//
//  Created by Jaehong Kang on 2022/07/20.
//

#if canImport(AuthenticationServices)

import AuthenticationServices

@available(iOS 12.0, macOS 10.15, macCatalyst 13.0, tvOS 16.0, watchOS 6.2, *)
extension Session {
    public func oAuth2Authorize(
        scopes: OAuth2Credential.Scopes,
        state: String = UUID().uuidString,
        callbackURL: URL,
        prompt: OAuth2AuthorizationPrompt = .consent,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) throws -> ASWebAuthenticationSession? {
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

        return ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme
        ) { callbackURL, error in
            guard let callbackURL = callbackURL else {
                completion?(.failure(error!))
                return
            }

            Task {
                do {
                    try await self.updateOAuth2Credential(authorizeCallbackURL: callbackURL, state: state)

                    completion?(.success(()))
                } catch {
                    completion?(.failure(error))
                }
            }
        }
    }
}

#endif
