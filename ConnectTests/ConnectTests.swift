//
//  ConnectTests.swift
//  ConnectTests
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import XCTest
@testable import Connect


@MainActor
final class ConnectTests: XCTestCase {

    func test_fetchApps_success_updateapps() async {
        let mockService = MockAppStoreService()
        
        let app1 = AppInfo(
            id: "1",
            versionId: "v1",
            name: "App One",
            bundleId: "com.test.one",
            version: "1.0",
            state: .inReview
           
        )

        let app2 = AppInfo(
            id: "2",
            versionId: "v2",
            name: "App Two",
            bundleId: "com.test.two",
            version: "1.1",
            state: .missingCompliance
        )

        let expectedApps = [app1, app2]
        
        mockService.fetchPendingAppsResult = .success(expectedApps)
        
        let sut = makeSUT(service: mockService)
        
        
        await sut.fetchApps()
        
        XCTAssertEqual(sut.apps.count, 2)
        XCTAssertEqual(sut.apps.map(\.id), ["1", "2"])
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    
    func makeSUT(service: MockAppStoreService) -> AppListViewModel {
        let sut = AppListViewModel(appStoreService: service)

        trackForMemoryLeaks(sut)

        return sut
    }
}


