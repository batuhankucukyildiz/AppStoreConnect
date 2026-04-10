//
//  AppStoreEndpoint.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation

enum AppStoreEndpoint: Endpoint {
    case fetchPendingApps
    case resolveCompliance(buildId: String, usesEncryption: Bool)
    case releaseApp(versionId: String)

    var path: String {
        switch self {
        case .fetchPendingApps:
            return "/builds"
        case .resolveCompliance(let buildId, _):
            return "/builds/\(buildId)"
        case .releaseApp:
            return "/appStoreVersionReleaseRequests"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPendingApps:
            return .get
        case .resolveCompliance:
            return .patch
        case .releaseApp:
            return .post
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchPendingApps:
            return [
                .init(name: "filter[expired]", value: "false"),
                .init(name: "filter[processingState]", value: "VALID"),
                .init(name: "include", value: "app,preReleaseVersion"),
                .init(name: "limit", value: "50"),
                .init(name: "sort", value: "-uploadedDate")
            ]
        case .resolveCompliance, .releaseApp:
            return []
        }
    }

    var headers: [String: String] {
        [
            "Content-Type": "application/json"
        ]
    }

    var body: Data? {
        switch self {
        case .fetchPendingApps:
            return nil

        case .resolveCompliance(let buildId, let usesEncryption):
            let payload: [String: Any] = [
                "data": [
                    "type": "builds",
                    "id": buildId,
                    "attributes": [
                        "usesNonExemptEncryption": usesEncryption
                    ]
                ]
            ]
            return try? JSONSerialization.data(withJSONObject: payload)

        case .releaseApp(let versionId):
            let payload: [String: Any] = [
                "data": [
                    "type": "appStoreVersionReleaseRequests",
                    "relationships": [
                        "appStoreVersion": [
                            "data": [
                                "type": "appStoreVersions",
                                "id": versionId
                            ]
                        ]
                    ]
                ]
            ]
            return try? JSONSerialization.data(withJSONObject: payload)
        }
    }
}
