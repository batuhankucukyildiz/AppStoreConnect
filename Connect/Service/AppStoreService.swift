//
//  AppStoreService.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import Foundation

class AppStoreService {
    static let shared = AppStoreService()
    private let baseURL = "https://api.appstoreconnect.apple.com/v1"

    private var token: String? {
        guard
            let issuerId   = KeychainManager.load(for: "issuerId"),
            let keyId      = KeychainManager.load(for: "keyId"),
            let privateKey = KeychainManager.load(for: "privateKey")
        else { return nil }
        return try? JWTGenerator.generate(issuerId: issuerId, keyId: keyId, privateKeyPEM: privateKey)
    }

    func fetchPendingApps() async throws -> [AppInfo] {
        guard let token else { throw ServiceError.missingCredentials }

        // TestFlight - export compliance bekleyen build'ler
        let urlStr = "\(baseURL)/builds?filter[expired]=false&filter[processingState]=VALID&include=app,preReleaseVersion&limit=50&sort=-uploadedDate"
        guard let url = URL(string: urlStr) else { return [] }

        var req = URLRequest(url: url)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: req)

        if let json = String(data: data, encoding: .utf8) {
            print("Builds: \(json)")
        }

        let response = try JSONDecoder().decode(BuildsResponse.self, from: data)
        return response.toAppInfoList()
    }

    func resolveCompliance(buildId: String, usesEncryption: Bool) async throws {
        guard let token else { throw ServiceError.missingCredentials }

        let url = URL(string: "\(baseURL)/builds/\(buildId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "data": [
                "type": "builds",
                "id": buildId,
                "attributes": [
                    "usesNonExemptEncryption": usesEncryption
                ]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (responseData, _) = try await URLSession.shared.data(for: request)

        if let json = String(data: responseData, encoding: .utf8) {
            print("Compliance response: \(json)")
        }
    }
    
    func releaseApp(versionId: String) async throws {
        guard let token else { throw ServiceError.missingCredentials }

        let url = URL(string: "\(baseURL)/appStoreVersionReleaseRequests")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "data": [
                "type": "appStoreVersionReleaseRequests",
                "relationships": [
                    "appStoreVersion": [
                        "data": ["type": "appStoreVersions", "id": versionId]
                    ]
                ]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        _ = try await URLSession.shared.data(for: request)
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
