//
//  ConnectApp.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 9.04.2026.
//

import SwiftUI

@main
struct ConnectApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}
