import XCEasy

/// Shared configuration for UI tests of the standalone SwiftUI example.
class SwiftUIExampleTestCase: XCEasyTestCase, SwiftUIPageObjectsProviding {
    // MARK: - XCEasy Lifecycle

    /// Applies deterministic framework and Allure settings before application launch.
    override func configuration() {
        SwiftUIExampleTestSetup.configure()
        super.configuration()
    }

    /// Adds platform metadata to every Allure result.
    override func beforeTest() {
        SwiftUIExampleTestSetup.addReportMetadata()
        super.beforeTest()
    }
}
