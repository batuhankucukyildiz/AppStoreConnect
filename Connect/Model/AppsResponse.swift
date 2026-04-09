//
//  AppsResponse.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


// MARK: - API Response Models

struct AppsResponse: Decodable {
    let data: [AppData]
    let included: [VersionData]?

    func toAppInfoList() -> [AppInfo] {
        data.compactMap { app in
            let version = included?.first(where: { v in
                v.type == "appStoreVersions" &&
                app.relationships?.appStoreVersions?.data?.contains(where: { $0.id == v.id }) == true
            })

            guard let stateRaw = version?.attributes.appStoreState,
                  let state = AppState(rawValue: stateRaw) else { return nil }

            return AppInfo(
                id: app.id,
                versionId: version?.id ?? "",
                name: app.attributes.name,
                bundleId: app.attributes.bundleId,
                version: version?.attributes.versionString ?? "?",
                state: state
            )
        }
    }
}

struct AppData: Decodable {
    let id: String
    let attributes: AppAttributes
    let relationships: AppRelationships?
}

struct AppAttributes: Decodable {
    let name: String
    let bundleId: String
}

struct AppRelationships: Decodable {
    let appStoreVersions: AppStoreVersionsRelation?
}

struct AppStoreVersionsRelation: Decodable {
    let data: [RelationData]?
}

struct RelationData: Decodable {
    let id: String
    let type: String
}

struct VersionData: Decodable {
    let id: String
    let type: String
    let attributes: VersionAttributes
}

struct VersionAttributes: Decodable {
    let versionString: String
    let appStoreState: String
}