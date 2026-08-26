import XCEasy

@Epic("XCEasy Examples")
@Feature("Components")
@Marker("SwiftUI")
final class SwiftUIComponentsTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI] Component input: {id}")
    @Story("Parameterized component input")
    @ParameterizedTest(
        name: "[{index}] SwiftUI input {id}",
        cases: [
            ComponentInputTestData(id: "latin", value: "XCEasy example"),
            ComponentInputTestData(id: "digits", value: "12345")
        ]
    )
    private func componentInput(_ data: ComponentInputTestData) {
        parameter("inputValue", value: data.value)

        given("the component gallery is open") {
            home.openComponents()
        }

        when("the user enters text into the sample field") {
            componentGallery.inputField
                .typeText(data.value)
        }

        then("the field contains the entered value") {
            componentGallery.inputField
                .assertValue(text: data.value)
        }
    }

    @DisplayName("[SwiftUI] Component selections and collection state")
    @Story("Component state")
    func testSelectionsAndCollectionState() {
        given("the component gallery is open") {
            home.openComponents()
        }

        when("the user selects the checkbox and second option") {
            componentGallery.termsCheckbox
                .tap()
            componentGallery.secondOptionButton
                .tap()
        }

        then("the controls expose the expected selected states") {
            softly("Check component states") {
                componentGallery.termsCheckbox
                    .assertIsSelected()
                componentGallery.firstOptionButton
                    .assertIsNotSelected()
                componentGallery.secondOptionButton
                    .assertIsSelected()
            }
        }

        and("the gallery collection exposes all items") {
            softly("Check component collection") {
                componentGallery.galleryListItems
                    .assertCount(4)
                componentGallery.galleryListItems
                    .assertIsNotEmpty()
                componentGallery.galleryListItems.first
                    .assertExists()
                componentGallery.galleryListItems.last
                    .assertExists()
            }
        }
    }

    @DisplayName("[SwiftUI] Stored banner POM resolves its replacement")
    @Story("Lazy Page Object resolution")
    func testStoredBannerPOMResolvesReplacement() {
        let banner = componentGallery.banner

        given("the component gallery is open") {
            home.openComponents()
        }

        and("the original banner is dismissed") {
            banner.dismiss()
        }

        when("the user restores the banner") {
            componentGallery.restoreBannerButton
                .tap()
        }

        then("the stored POM resolves the replacement banner") {
            banner.assertIsDisplayed()
            banner.title
                .assertLabel(value: "Special offer 2")
        }
    }
}
