import Foundation
import Security

/// Clears application-owned state when explicitly requested by the UI-test process.
enum UITestStateReset {
    private static let environmentKey = "XC_EASY_RESET_APP_STATE"

    static func performIfRequested() {
        guard ProcessInfo.processInfo.environment[environmentKey] == "1" else { return }

        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
        }
        clearKeychain()
        clearWritableDirectory(.applicationSupportDirectory)
        clearWritableDirectory(.cachesDirectory)
        clearWritableDirectory(.documentDirectory)
    }

    private static func clearKeychain() {
        [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ].forEach { itemClass in
            SecItemDelete([kSecClass: itemClass] as CFDictionary)
        }
    }

    private static func clearWritableDirectory(_ directory: FileManager.SearchPathDirectory) {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else { return }
        try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .forEach { try FileManager.default.removeItem(at: $0) }
    }
}
