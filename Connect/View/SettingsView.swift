//
//  SettingsView.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        Form {
            Section("App Store Connect API") {
                TextField("Issuer ID", text: $vm.issuerId)
                TextField("Key ID", text: $vm.keyId)
                TextEditor(text: $vm.privateKey)
                    .font(.system(.caption, design: .monospaced))
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.secondary.opacity(0.3))
                    )
            }

            Button(vm.saved ? "✓ Kaydedildi" : "Kaydet") {
                vm.save()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 450, height: 380)
    }
}
