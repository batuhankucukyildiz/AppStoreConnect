//
//  AppListView.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import SwiftUI

struct AppListView: View {
    @ObservedObject var vm: AppListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                ForEach(vm.apps) { app in
                    AppRowView(app: app, vm: vm)
                    Divider()
                }
            }
        }
        .frame(maxHeight: 400)
    }
}

// AppRowView.swift
struct AppRowView: View {
    let app: AppInfo
    @ObservedObject var vm: AppListViewModel

    var isReleasing: Bool { vm.releasingIds.contains(app.id) }

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(app.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name).font(.system(size: 13, weight: .semibold))
                Text("v\(app.version)").font(.caption).foregroundColor(.secondary)
                Text(app.state.displayName)
                    .font(.caption2)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(stateColor.opacity(0.15))
                    .foregroundColor(stateColor)
                    .cornerRadius(4)
            }

            Spacer()

            if isReleasing {
                ProgressView().scaleEffect(0.7)
            } else {
                if app.state == .pendingRelease {
                    Button {
                        Task { await vm.release(app: app) }
                    } label: {
                        Text("Release").font(.caption).bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }

                if app.state == .missingCompliance {
                    Menu("Compliance") {
                        Button("Şifreleme Yok") {
                            Task { await vm.resolve(app: app, usesEncryption: false) }
                        }
                        Button("Şifreleme Var") {
                            Task { await vm.resolve(app: app, usesEncryption: true) }
                        }
                    }
                    .menuStyle(.borderedButton)
                    .controlSize(.small)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    var stateColor: Color {
        switch app.state {
        case .waitingForReview:  return .orange
        case .inReview:          return .blue
        case .pendingRelease:    return .green
        case .readyForSale:      return .gray
        case .missingCompliance: return .yellow
        }
    }
}
