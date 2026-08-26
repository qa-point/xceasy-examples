import XCEasy

@Epic("XCEasy Examples")
@Feature("Failure showcase: basic assertion")
@Marker("FailureShowcase")
@Tag("SwiftUI")
final class SwiftUIBasicFailureShowcaseTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI][Expected failure] Home title mismatch")
    @Story("Basic assertion failure")
    @Muted
    func testHomeTitleMismatch() {
        given("the home screen is open") {
            home.assertIsDisplayed()
        }

        then("an intentionally incorrect title is expected") {
            home.title
                .assertLabel(value: "Incorrect SwiftUI title")
        }
    }
}
