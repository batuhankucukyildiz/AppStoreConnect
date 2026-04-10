//
//  MockAppStoreService.swift
//  ConnectTests
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import Foundation
@testable import Connect

final class MockAppStoreService: AppStoreServiceProtocol {
    var fetchPendingAppsResult: Result<[AppInfo], Error> = .success([])
    var releaseAppResult: Result<Void, Error> = .success(())
    var resolveComplianceResult: Result<Void, Error> = .success(())

    var releaseCalledVersionId: String?
    var resolveCalledBuildId: String?
    var resolveCalledUsesEncryption: Bool?
    
    func fetchPendingApps() async throws -> [AppInfo] {
        switch fetchPendingAppsResult {
        case .success(let apps):
            return apps
        case .failure(let error):
            throw error
        }
    }

    func releaseApp(versionId: String) async throws {
        releaseCalledVersionId = versionId
        switch releaseAppResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    func resolveCompliance(buildId: String, usesEncryption: Bool) async throws {
        resolveCalledBuildId = buildId
        resolveCalledUsesEncryption = usesEncryption
        switch resolveComplianceResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
