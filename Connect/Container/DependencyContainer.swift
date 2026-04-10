//
//  DependencyContainer.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//


import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    private(set) lazy var keychainService: KeychainServiceProtocol = {
        return KeychainManager()
    }()

    private init() {}
}
