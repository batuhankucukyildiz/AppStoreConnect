//
//  MenuBarView.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import SwiftUI

struct MenuBarView: View {
    @StateObject private var vm = AppListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App Store Manager")
                    .font(.headline)
                Spacer()
                Button {
                    Task { await vm.fetchApps() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .disabled(vm.isLoading)
            }
            .padding()

            Divider()

            if vm.isLoading {
                ProgressView("Yükleniyor...")
                    .padding(40)
            } else if let error = vm.errorMessage {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            } else if vm.apps.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("Bekleyen uygulama yok")
                        .foregroundColor(.secondary)
                }
                .padding(40)
            } else {
                AppListView(vm: vm)
            }

            Divider()

            HStack {
                SettingsLink {
                    Text("Ayarlar")
                }
                Spacer()
                Button("Çıkış") { NSApp.terminate(nil) }
            }
            .padding(10)
        }
        .frame(width: 380)
        .task { await vm.fetchApps() }
    }
}
