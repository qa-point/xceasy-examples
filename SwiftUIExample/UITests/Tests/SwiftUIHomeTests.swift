import XCEasy

@Epic("XCEasy Examples")
@Feature("Home")
@Marker("SwiftUI")
final class SwiftUIHomeTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI] Home exposes every example feature")
    @Description("Demonstrates plural Allure metadata while checking the SwiftUI example navigation entry points.")
    @Epics("XCEasy Examples", "Mobile examples")
    @Features("Home", "Navigation")
    @Stories("Feature navigation", "Accessibility")
    @Tags("SwiftUI", "Smoke", "Metadata showcase")
    @Owner("Owner1")
    @Lead("Lead1")
    @Severity(.critical)
    @AllureId("2001")
    @Issues("TEST-ISSUE-201", "TEST-ISSUE-202")
    @TmsLinks("TEST-CASE-201", "TEST-CASE-202")
    @Links(
        "https://github.com/qa-point/xceasy",
        "https://allurereport.org/"
    )
    func testHomeShowsEveryFeature() {
        given("the SwiftUI example application is launched") {
            home.assertIsDisplayed()
        }

        then("the home screen exposes every feature") {
            home.assertReady()
        }
    }
}
