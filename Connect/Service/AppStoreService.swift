//
//  AppStoreService.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import Foundation


protocol AppStoreServiceProtocol {
    func fetchPendingApps() async throws -> [AppInfo]
    func resolveCompliance(buildId: String, usesEncryption: Bool) async throws
    func releaseApp(versionId: String) async throws
}

final class AppStoreService: AppStoreServiceProtocol {
    static let shared = AppStoreService()

    private let client: APIClientProtocol

    init(
        client: APIClientProtocol = APIClient(
            baseURL: "https://api.appstoreconnect.apple.com/v1",
            tokenProvider: AppStoreTokenProvider()
        )
    ) {
        self.client = client
    }

    func fetchPendingApps() async throws -> [AppInfo] {
        let response = try await client.send(
            AppStoreEndpoint.fetchPendingApps,
            responseType: BuildsResponse.self
        )
        return response.toAppInfoList()
    }

    func resolveCompliance(buildId: String, usesEncryption: Bool) async throws {
        try await client.send(
            AppStoreEndpoint.resolveCompliance(
                buildId: buildId,
                usesEncryption: usesEncryption
            )
        )
    }

    func releaseApp(versionId: String) async throws {
        try await client.send(
            AppStoreEndpoint.releaseApp(versionId: versionId)
        )
    }

    enum ServiceError: Error {
        case missingCredentials
    }
}

// MARK: - Builds Response Models
struct BuildsResponse: Decodable {
    let data: [BuildData]
    let included: [IncludedData]?

    func toAppInfoList() -> [AppInfo] {
        data.compactMap { build in
            guard build.attributes.usesNonExemptEncryption == nil else { return nil }

            let appData = included?.first(where: {
                $0.type == "apps" &&
                build.relationships?.app?.data?.id == $0.id
            })

            let versionData = included?.first(where: {
                $0.type == "preReleaseVersions" &&
                build.relationships?.preReleaseVersion?.data?.id == $0.id
            })

            return AppInfo(
                id: build.id,
                versionId: build.id,
                name: appData?.attributes.name ?? "Bilinmeyen App",
                bundleId: appData?.attributes.bundleId ?? "",
                version: "\(versionData?.attributes.version ?? "?") (\(build.attributes.version))",
                state: .missingCompliance
            )
        }
    }
}

struct BuildData: Decodable {
    let id: String
    let attributes: BuildAttributes
    let relationships: BuildRelationships?
}

struct BuildAttributes: Decodable {
    let version: String
    let usesNonExemptEncryption: Bool?
    let processingState: String
}

struct BuildRelationships: Decodable {
    let app: RelationshipItem?
    let preReleaseVersion: RelationshipItem?
}

struct RelationshipItem: Decodable {
    let data: RelationData?
}

struct IncludedData: Decodable {
    let id: String
    let type: String
    let attributes: IncludedAttributes
}

struct IncludedAttributes: Decodable {
    let name: String?
    let bundleId: String?
    let version: String?
}

struct BuildBetaDetailResponse: Decodable {
    let data: BuildBetaDetailData
}

struct BuildBetaDetailData: Decodable {
    let id: String
}
