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
    
    func test_fetchApps_failure_setsErrorMessage() async {
        let mockService = MockAppStoreService()
        mockService.fetchPendingAppsResult = .failure(MockError.sample)

        let sut = makeSUT(service: mockService)

        await sut.fetchApps()

        XCTAssertTrue(sut.apps.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_release_success_removesApp() async {
        let mockService = MockAppStoreService()
        let sut = makeSUT(service: mockService)
        
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
        
        sut.apps = [app1, app2]
        
        await sut.release(app: app1)
        
        
        XCTAssertEqual(mockService.releaseCalledVersionId, "v1")
        XCTAssertEqual(sut.apps.map(\.id), ["2"])
        XCTAssertFalse(sut.releasingIds.contains("1"))
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_release_failure_keepsAppAndSetsError() async {
        let mockService = MockAppStoreService()
        
        mockService.releaseAppResult = .failure(MockError.sample)
        
        let sut = makeSUT(service: mockService)
        
        let app = AppInfo(
            id: "1",
            versionId: "v1",
            name: "App One",
            bundleId: "com.test.one",
            version: "1.0",
            state: .inReview
        )
        
        sut.apps.append(app)
        
        await sut.release(app: app)
        
        XCTAssertEqual(sut.apps.map(\.id), ["1"])
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.releasingIds.contains("1"))
    }
    
    func test_resolve_success_removesApp() async {
        let mockService = MockAppStoreService()
        let sut = makeSUT(service: mockService)
        
        let app = AppInfo(
            id: "1",
            versionId: "v1",
            name: "App One",
            bundleId: "com.test.one",
            version: "1.0",
            state: .inReview
        )
        
        sut.apps = [app]
        
        await sut.resolve(app: app, usesEncryption: true)
        
        XCTAssertEqual(mockService.resolveCalledBuildId, "v1")
        XCTAssertEqual(mockService.resolveCalledUsesEncryption, true)
        XCTAssertTrue(sut.apps.isEmpty)
        XCTAssertFalse(sut.releasingIds.contains("1"))
    }
    
    func test_resolve_failure_keepsAppAndSetsErrorMessage() async {
        let mockService = MockAppStoreService()
        mockService.resolveComplianceResult = .failure(MockError.sample)
        
        let sut = makeSUT(service: mockService)
        
        let app = AppInfo(
            id: "1",
            versionId: "build-123",
            name: "Test App",
            bundleId: "com.test.app",
            version: "1.0",
            state: .missingCompliance
        )
        
        sut.apps = [app]
        
        await sut.resolve(app: app, usesEncryption: true)
        
        XCTAssertEqual(mockService.resolveCalledBuildId, "build-123")
        XCTAssertEqual(mockService.resolveCalledUsesEncryption, true)
        XCTAssertEqual(sut.apps.count, 1)
        XCTAssertEqual(sut.apps.first?.id, "1")
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.releasingIds.contains("1"))
    }
    
    func makeSUT(service: MockAppStoreService) -> AppListViewModel {
        let sut = AppListViewModel(appStoreService: service)

        trackForMemoryLeaks(sut)

        return sut
    }
}


