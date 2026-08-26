import XCEasy

enum UIKitExampleTestSetup {
    // MARK: - Configuration

    static func configure() {
        XCEasyConfig.apply(
            bundleId: "com.qa-point.xceasy-examples.uikit",
            localization: .en
        )
        XCEasyAllureConfig.apply(linkPatterns: [
            "issue": "https://issues.example.test/{}",
            "tms": "https://tms.example.test/{}"
        ])
        configureStateIsolation()
    }

    private static func configureStateIsolation() {
        guard ProcessInfo.processInfo.environment["XC_EASY_STATE_ISOLATION"] == "app_reset_hook" else { return }
        LaunchEnvironmentManager.set("1", for: "XC_EASY_RESET_APP_STATE")
    }

    // MARK: - Report Metadata

    static func addReportMetadata() {
        suite("UIKitExampleUITests")
        tag("UIKit", "UI", "Example")
        label("platform", "UIKit")
    }
}
