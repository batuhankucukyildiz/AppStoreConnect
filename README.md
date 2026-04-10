Connect (App Store Connect Manager)
Connect is a macOS utility designed to streamline the management of your App Store Connect applications. It specifically focuses on managing apps pending Export Compliance and other pre-release statuses for TestFlight, directly from your desktop.

By leveraging the App Store Connect API, Connect allows developers to handle tedious administrative tasks without opening a web browser.

✨ Features
Compliance Management: Quickly resolve "Missing Compliance" status for builds waiting for TestFlight.

Secure Credential Storage: Sensitive information like Issuer ID, Key ID, and Private Key are stored securely in the macOS Keychain using the Security framework.

Real-time Updates: Built with SwiftUI and Combine for a reactive and fluid user experience.

Robust Architecture: Developed using Dependency Injection and a DI Container pattern for high testability and maintainability.

🔐 Security
Security is a top priority for Connect. The application does not store your App Store Connect API keys in UserDefaults or plain text files. Instead:

It uses the Keychain Service (AES-256 encryption equivalent) to ensure your private keys remain private.

Credentials are only accessed during JWT (JSON Web Token) generation for API requests.

🚀 Getting Started
Prerequisites
To use this app, you need to generate API credentials from your App Store Connect account:

Log in to App Store Connect.

Go to Users and Access > Integrations > App Store Connect API.

Generate an API Key (Admin or App Manager access is recommended).

Note down your Issuer ID, Key ID, and download the .p8 Private Key file.

Installation
Clone the repository:

Bash

git clone [https://github.com/yourusername/Connect.git](https://github.com/batuhankucukyildiz/AppStoreConnect)
Open Connect.xcodeproj in Xcode.

Build and Run the project (Cmd + R).

Configuration
Launch the app and navigate to Settings.

Enter your Issuer ID and Key ID.

Open your .p8 file in a text editor, copy the content, and paste it into the Private Key field.

Click Save. Your credentials are now safely stored in your system Keychain.

