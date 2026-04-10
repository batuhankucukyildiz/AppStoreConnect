//
//  SettingsViewModel.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//


import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var issuerId: String = ""
    @Published var keyId: String = ""
    @Published var privateKey: String = ""
    @Published var saved = false

    private let keychainService: KeychainServiceProtocol

    init(keychainService: KeychainServiceProtocol = DependencyContainer.shared.keychainService) {
        self.keychainService = keychainService
        load()
    }

    func load() {
        issuerId = keychainService.load(for: "issuerId") ?? ""
        keyId = keychainService.load(for: "keyId") ?? ""
        privateKey = keychainService.load(for: "privateKey") ?? ""
    }

    func save() {
        keychainService.save(issuerId, for: "issuerId")
        keychainService.save(keyId, for: "keyId")
        keychainService.save(privateKey, for: "privateKey")
        saved = true
    }
}
