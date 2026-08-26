import XCEasy

@Epic("XCEasy Examples")
@Feature("Failure showcase: parameterized assertions")
@Marker("FailureShowcase")
@Tag("SwiftUI")
final class SwiftUIParameterizedFailureShowcaseTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI][Expected failure] Intentional title mismatch: {id}")
    @Story("Parameterized assertion failures")
    @ParameterizedTest(
        name: "[{index}] SwiftUI intentional mismatch {id}",
        cases: [
            ExpectedTitleFailureTestData(id: "empty", expectedTitle: ""),
            ExpectedTitleFailureTestData(id: "other-platform", expectedTitle: "XCEasy UIKit Example"),
            ExpectedTitleFailureTestData(id: "unknown-product", expectedTitle: "Product Catalog")
        ]
    )
    private func homeTitleMismatch(_ data: ExpectedTitleFailureTestData) {
        parameter("expectedTitle", value: data.expectedTitle)

        given("the home screen is open") {
            home.assertIsDisplayed()
        }

        then("the parameterized incorrect title is expected") {
            home.title
                .assertLabel(value: data.expectedTitle)
        }
    }
}
