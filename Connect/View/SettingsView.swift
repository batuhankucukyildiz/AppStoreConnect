//
//  SettingsView.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//


import SwiftUI

struct SettingsView: View {
    @State private var issuerId  = KeychainManager.load(for: "issuerId")  ?? ""
    @State private var keyId     = KeychainManager.load(for: "keyId")     ?? ""
    @State private var privateKey = KeychainManager.load(for: "privateKey") ?? ""
    @State private var saved = false

    var body: some View {
        Form {
            Section("App Store Connect API") {
                TextField("Issuer ID", text: $issuerId)
                TextField("Key ID", text: $keyId)
                TextEditor(text: $privateKey)
                    .font(.system(.caption, design: .monospaced))
                    .frame(height: 120)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.3)))
            }

            Button(saved ? "✓ Kaydedildi" : "Kaydet") {
                KeychainManager.save(issuerId,   for: "issuerId")
                KeychainManager.save(keyId,      for: "keyId")
                KeychainManager.save(privateKey, for: "privateKey")
                saved = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { saved = false }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 450, height: 380)
    }
}