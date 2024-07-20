//
//  RESTSession+Actor.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

extension RESTSession {
    actor Actor {
        var oAuth2Credential: OAuth2Credential?
    }
}

extension RESTSession.Actor {
    func updateOAuth2Credential(_ oAuth2Credential: OAuth2Credential?) {
        self.oAuth2Credential = oAuth2Credential
    }
}
