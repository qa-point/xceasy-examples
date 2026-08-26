import XCEasy

/// Reference-only base class showing the extended UIKit test configuration.
/// Existing UIKit tests intentionally do not inherit from this class.
class UIKitAdvancedExampleTestCase: XCEasyTestCase {
    // MARK: - XCEasy Lifecycle

    override func configuration() {
        XCEasyConfig.apply(
            bundleId: "com.qa-point.xceasy-examples.uikit",
            findTimeout: 5,
            actionTimeout: 5,
            assertionTimeout: 5,
            localization: .en,
            printLogToConsole: true,
            uiQueryEvidenceLevel: .detailed,
            performance: .init(
                level: .detailed,
                defaultBudgetMilliseconds: 2_000,
                budgetPolicy: .warn
            ),
            healing: .init(
                mode: .suggest,
                minimumConfidence: 0.8,
                minimumScoreGap: 0.15
            ),
            diagnosticSnapshotByteLimit: 512_000
        )
        XCEasyAllureConfig.apply(linkPatterns: [
            "issue": "https://issues.example.test/{}",
            "tms": "https://tms.example.test/{}"
        ])
        super.configuration()
    }

    override func beforeTest() {
        suite("UIKitAdvancedExampleUITests")
        tag("UIKit", "UI", "Advanced configuration")
        super.beforeTest()
    }
}
