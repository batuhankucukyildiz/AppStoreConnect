//
//  MockKeychainService.swift
//  ConnectTests
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation
@testable import Connect


final class MockKeychainService: KeychainServiceProtocol {
    
    var storage: [String: String] = [:]
    
    var saveCalled = false
    
    func load(for key: String) -> String? {
        return storage[key]
    }
    
    func save(_ value: String, for key: String) {
        storage[key] = value
        saveCalled = true
    }
    
}
