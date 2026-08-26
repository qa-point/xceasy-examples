import XCEasy

@Epic("XCEasy Examples")
@Feature("Dynamic content")
@Marker("UIKit")
final class UIKitDynamicContentTests: UIKitExampleTestCase {
    @DisplayName("[UIKit] Recommendation card is initially absent")
    @Story("Recommendation lifecycle")
    func testRecommendationCardIsInitiallyAbsent() {
        given("the dynamic content screen is open") {
            home.openDynamicContent()
        }

        then("the recommendation card is initially absent") {
            dynamicContent.recommendationCard
                .assertDoesNotExist(timeout: 1)
        }
    }

    @DisplayName("[UIKit] Recommendation card appears after loading")
    @Story("Recommendation loading")
    func testRecommendationCardAppearsAfterLoading() {
        given("the dynamic content screen is open") {
            home.openDynamicContent()
        }

        when("the user requests dynamic content") {
            dynamicContent.loadContentButton
                .tap()
        }

        then("the loading indicator is displayed") {
            dynamicContent.loadingIndicator
                .assertIsDisplayed(timeout: 1)
        }

        and("the recommendation card appears") {
            dynamicContent.recommendationCard
                .assertIsDisplayed(timeout: 4)
            dynamicContent.loadingIndicator
                .assertDoesNotExist(timeout: 1)
            dynamicContent.recommendationTitle
                .assertLabel(value: "Recommended plan")
        }
    }

    @DisplayName("[UIKit] Recommendation details appear after expansion")
    @Story("Recommendation details")
    func testRecommendationDetailsAreDisplayedAfterExpansion() {
        given("the recommendation card is loaded") {
            home.openDynamicContent()
            dynamicContent.loadContentButton
                .tap()
            dynamicContent.recommendationCard
                .waitForDisplayed(timeout: 4)
        }

        when("the user expands the recommendation details") {
            dynamicContent.toggleDetailsButton
                .tap()
        }

        then("the details are displayed") {
            dynamicContent.recommendationDetails
                .assertIsDisplayed()
        }
    }

    @DisplayName("[UIKit] Recommendation card can be removed")
    @Story("Recommendation lifecycle")
    func testRecommendationCardIsRemoved() {
        given("the recommendation card is loaded") {
            home.openDynamicContent()
            dynamicContent.loadContentButton
                .tap()
            dynamicContent.recommendationCard
                .waitForDisplayed(timeout: 4)
        }

        when("the user removes the recommendation card") {
            dynamicContent.removeRecommendationButton
                .tap()
        }

        then("the card is removed from the accessibility tree") {
            dynamicContent.recommendationCard
                .assertDoesNotExist(timeout: 2)
        }
    }

    @DisplayName("[UIKit] Recommendation card can be restored")
    @Story("Recommendation lifecycle")
    func testRecommendationCardIsRestored() {
        given("the recommendation card is removed") {
            home.openDynamicContent()
            dynamicContent.loadContentButton
                .tap()
            dynamicContent.recommendationCard
                .waitForDisplayed(timeout: 4)
            dynamicContent.removeRecommendationButton
                .tap()
            dynamicContent.restoreRecommendationButton
                .waitForHittable(timeout: 2)
        }

        when("the user restores the recommendation card") {
            dynamicContent.restoreRecommendationButton
                .tap()
        }

        then("the recommendation card is displayed again") {
            dynamicContent.recommendationCard
                .assertIsDisplayed()
        }
    }
}
