//
//  AppInfo.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import Foundation

struct AppInfo: Identifiable {
    let id: String          // App ID (App Store Connect)
    let versionId: String   // Version ID
    let name: String
    let bundleId: String
    let version: String
    let state: AppState
}

enum AppState: String {
    case waitingForReview    = "WAITING_FOR_REVIEW"
    case inReview            = "IN_REVIEW"
    case pendingRelease      = "PENDING_DEVELOPER_RELEASE"
    case missingCompliance = "WAITING_FOR_EXPORT_COMPLIANCE"
    case readyForSale        = "READY_FOR_SALE"

    var displayName: String {
        switch self {
        case .waitingForReview:  return "Review Bekliyor"
        case .inReview:          return "İnceleniyor"
        case .pendingRelease:    return "Release Bekliyor"
        case .missingCompliance: return "Export Compliance Bekliyor"
        case .readyForSale:      return "Yayında"
        }
    }
}
