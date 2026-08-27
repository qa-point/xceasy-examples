import XCEasy

@Epic("XCEasy Examples")
@Feature("Overlays")
@Marker("SwiftUI")
final class SwiftUIOverlaysTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI] Confirmation alert is displayed")
    @Story("System alert")
    func testConfirmationAlertIsDisplayed() {
        given("the overlays screen is open") {
            home.openOverlays()
        }

        when("the user opens the confirmation alert") {
            overlays.showAlertButton
                .tap()
        }

        then("the confirmation alert is displayed") {
            overlays.confirmationAlert
                .assertIsDisplayed()
        }
    }

    @DisplayName("[SwiftUI] Confirmation alert displays its result")
    @Story("System alert")
    func testConfirmationAlertDisplaysResultAfterConfirmation() {
        given("the confirmation alert is open") {
            home.openOverlays()
            overlays.showAlertButton
                .tap()
        }

        when("the user confirms the alert") {
            overlays.confirmationAlert
                .confirm()
        }

        then("the confirmation result is displayed") {
            overlays.confirmationResultLabel
                .assertLabel(value: "Action confirmed")
        }
    }

    @DisplayName("[SwiftUI] Feature sheet is displayed")
    @Story("Feature sheet")
    func testFeatureSheetIsDisplayed() {
        given("the overlays screen is open") {
            home.openOverlays()
        }

        when("the user opens the feature sheet") {
            overlays.showSheetButton
                .tap()
        }

        then("the feature sheet is displayed") {
            overlays.sheetTitle
                .assertLabel(value: "Feature details")
        }
    }

    @DisplayName("[SwiftUI] Feature sheet is removed after closing")
    @Story("Feature sheet")
    func testFeatureSheetIsRemovedAfterClosing() {
        given("the feature sheet is open") {
            home.openOverlays()
            overlays.showSheetButton
                .tap()
        }

        when("the user closes the feature sheet") {
            overlays.closeSheetButton
                .tap()
        }

        then("the feature sheet is removed") {
            overlays.sheetTitle
                .assertDoesNotExist(timeout: 2)
        }
    }

    @DisplayName("[SwiftUI] Toast appears and leaves the UI tree")
    @Story("Toast lifecycle")
    func testToastAppearsAndLeavesTree() {
        given("the overlays screen is open") {
            home.openOverlays()
        }

        when("the user requests a toast") {
            overlays.showToastButton
                .tap()
        }

        then("the toast is displayed") {
            overlays.toastMessage
                .assertLabel(value: "Settings saved")
        }

        and("the toast is eventually removed from the tree") {
            overlays.toastMessage
                .assertDoesNotExist(timeout: 20)
        }
    }
}
