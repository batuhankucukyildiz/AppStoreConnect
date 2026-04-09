//
//  JWTGenerator.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import Foundation
import CryptoKit

struct JWTGenerator {
    static func generate(issuerId: String, keyId: String, privateKeyPEM: String) throws -> String {
        let header = #"{"alg":"ES256","kid":"\#(keyId)","typ":"JWT"}"#
        let now = Int(Date().timeIntervalSince1970)
        let payload = #"{"iss":"\#(issuerId)","iat":\#(now),"exp":\#(now + 1200),"aud":"appstoreconnect-v1"}"#

        let headerB64  = Data(header.utf8).base64URLEncoded
        let payloadB64 = Data(payload.utf8).base64URLEncoded
        let signingInput = "\(headerB64).\(payloadB64)"

        let key = try P256.Signing.PrivateKey(pemRepresentation: privateKeyPEM)
        let signature = try key.signature(for: Data(signingInput.utf8))
        let signatureB64 = signature.rawRepresentation.base64URLEncoded

        return "\(signingInput).\(signatureB64)"
    }
}

private extension Data {
    var base64URLEncoded: String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}