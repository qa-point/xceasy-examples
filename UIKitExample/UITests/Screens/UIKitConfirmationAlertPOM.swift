import XCEasy

/// Page object for the system confirmation alert presented by the UIKit overlays screen.
struct UIKitConfirmationAlertPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit confirmation alert"
    var element: XCEasyUIElement {
        find(type: .alert, text: "Confirm action", desc: componentName)
    }

    // MARK: - Elements

    private var confirmButton: XCEasyUIElement {
        element.child(type: .button, text: "Confirm", desc: "Confirm action")
    }

    // MARK: - Actions

    @discardableResult
    func confirm() -> Self {
        step("Confirm action") {
            confirmButton.tap()
        }
        return self
    }
}
