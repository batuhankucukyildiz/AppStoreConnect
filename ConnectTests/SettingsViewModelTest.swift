//
//  SettingsViewModelTest.swift
//  ConnectTests
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import XCTest
@testable import Connect

@MainActor
final class SettingsViewModelTest: XCTestCase {
    
    func test_init_loadsCredentialsFromKeychain() {
        let mockKeychainService = MockKeychainService()
        
        mockKeychainService.storage = [
            "issuerId": "test-issuer",
            "keyId": "test-key-id",
            "privateKey": "test-private-key"
        ]
        
        let sut = makeSUT(keychainService: mockKeychainService)
        
        XCTAssertEqual(sut.issuerId, "test-issuer")
        XCTAssertEqual(sut.keyId, "test-key-id")
        XCTAssertEqual(sut.privateKey, "test-private-key")
    }
    
    func test_save_persistsDataInKeychain() {
        let mockKeychainService = MockKeychainService()
        let sut = makeSUT(keychainService: mockKeychainService)
        
        sut.issuerId = "test-issuer"
        sut.keyId = "test-key-id"
        sut.privateKey = "test-private-key"
        sut.save()
        
        XCTAssertTrue(mockKeychainService.saveCalled)
        XCTAssertEqual(mockKeychainService.storage["issuerId"], "test-issuer")
        XCTAssertEqual(mockKeychainService.storage["keyId"], "test-key-id")
        XCTAssertEqual(sut.saved, true)
    }
    
    func makeSUT(keychainService: KeychainServiceProtocol) -> SettingsViewModel {
        let sut = SettingsViewModel(keychainService: keychainService)
        trackForMemoryLeaks(sut)
        
        return sut
    }
}
