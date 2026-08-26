import XCEasy

/// Page object for the mocked UIKit authorization flow.
struct UIKitAuthorizationPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit authorization"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Authorization.Screen", desc: componentName)
    }

    // MARK: - Elements

    var loginField: XCEasyUIElement {
        element.child(type: .textField, identifier: "UIKitExample.Authorization.LoginField")
    }
    var passwordField: XCEasyUIElement {
        element.child(type: .secureTextField, identifier: "UIKitExample.Authorization.PasswordField")
    }
    var submitButton: XCEasyUIElement {
        element.child(type: .button, identifier: "UIKitExample.Authorization.SubmitButton")
    }
    var validationErrorContainer: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Authorization.Error")
    }
    var loadingIndicator: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Authorization.Loader")
    }
    var successTitle: XCEasyUIElement {
        find(identifier: "UIKitExample.Authorization.SuccessTitle")
    }

    // MARK: - Actions

    @discardableResult
    func signIn(login loginValue: String, password passwordValue: String) -> Self {
        step("Fill and submit credentials") {
            loginField.typeText(loginValue)
            passwordField.typeText(passwordValue)
            submitButton.tap()
        }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertError(_ message: String) -> Self {
        step("Check validation error") {
            validationErrorContainer.child(type: .staticText, text: message)
                .assertIsDisplayed()
        }
        return self
    }
}
