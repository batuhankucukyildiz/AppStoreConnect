//
//  TokenProvider.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation

protocol TokenProvider {
    func fetchToken() throws -> String
}

final class AppStoreTokenProvider: TokenProvider {
    func fetchToken() throws -> String {
        guard
            let issuerId = DependencyContainer.shared.keychainService.load(for: "issuerId"),
            let keyId = DependencyContainer.shared.keychainService.load(for: "keyId"),
            let privateKey = DependencyContainer.shared.keychainService.load(for: "privateKey"),
            let token = try? JWTGenerator.generate(
                issuerId: issuerId,
                keyId: keyId,
                privateKeyPEM: privateKey
            )
        else {
            throw AppStoreService.ServiceError.missingCredentials
        }

        return token
    }
}
