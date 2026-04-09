//
//  AppListViewModel.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import SwiftUI

@MainActor
class AppListViewModel: ObservableObject {
    @Published var apps: [AppInfo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var releasingIds: Set<String> = []

    func fetchApps() async {
        isLoading = true
        errorMessage = nil
        do {
            apps = try await AppStoreService.shared.fetchPendingApps()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func release(app: AppInfo) async {
        releasingIds.insert(app.id)
        do {
            try await AppStoreService.shared.releaseApp(versionId: app.versionId)
            apps.removeAll { $0.id == app.id }
        } catch {
            errorMessage = "Release hatası: \(error.localizedDescription)"
        }
        releasingIds.remove(app.id)
    }
    
    func resolve(app: AppInfo, usesEncryption: Bool) async {
        releasingIds.insert(app.id)
        do {
            try await AppStoreService.shared.resolveCompliance(buildId: app.versionId, usesEncryption: usesEncryption)
            apps.removeAll { $0.id == app.id }
        } catch {
            errorMessage = "Hata: \(error.localizedDescription)"
        }
        releasingIds.remove(app.id)
    }
}
