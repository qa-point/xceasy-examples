import XCEasy

@Epic("XCEasy Examples")
@Feature("Failure showcase: basic assertion")
@Marker("FailureShowcase")
@Tag("UIKit")
final class UIKitBasicFailureShowcaseTests: UIKitExampleTestCase {
    @DisplayName("[UIKit][Expected failure] Home title mismatch")
    @Story("Basic assertion failure")
    @Flaky
    func testHomeTitleMismatch() {
        given("the home screen is open") {
            home.assertIsDisplayed()
        }

        then("an intentionally incorrect title is expected") {
            home.title
                .assertLabel(value: "Incorrect UIKit title")
        }
    }
}
