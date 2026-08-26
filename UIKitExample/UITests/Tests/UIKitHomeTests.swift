import XCEasy

@Epic("XCEasy Examples")
@Feature("Home")
@Marker("UIKit")
final class UIKitHomeTests: UIKitExampleTestCase {
    @DisplayName("[UIKit] Home exposes every example feature")
    @Description("Verifies that the UIKit example exposes every supported UI-test feature from its home screen.")
    @Story("Feature navigation")
    @Owner("Owner1")
    @Lead("Lead1")
    @Severity(.blocker)
    @AllureId("1001")
    @Issue("TEST-ISSUE-101")
    @TmsLink("TEST-CASE-101")
    @Link(
        name: "XCEasy documentation",
        url: "https://github.com/qa-point/xceasy",
        type: "documentation"
    )
    func testHomeShowsEveryFeature() {
        given("the UIKit example application is launched") {
            home.assertIsDisplayed()
        }

        then("the home screen exposes every feature") {
            home.assertReady()
        }
    }
}
