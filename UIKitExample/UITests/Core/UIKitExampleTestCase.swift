import XCEasy

/// Shared configuration for UI tests of the standalone UIKit example.
class UIKitExampleTestCase: XCEasyTestCase, UIKitPageObjectsProviding {
    // MARK: - XCEasy Lifecycle

    /// Applies deterministic framework and Allure settings before application launch.
    override func configuration() {
        UIKitExampleTestSetup.configure()
        super.configuration()
    }

    /// Adds platform metadata to every Allure result.
    override func beforeTest() {
        UIKitExampleTestSetup.addReportMetadata()
        super.beforeTest()
    }
}
