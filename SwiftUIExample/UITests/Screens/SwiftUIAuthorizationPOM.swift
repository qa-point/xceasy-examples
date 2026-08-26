import XCEasy

/// Page object for the mocked SwiftUI authorization flow.
struct SwiftUIAuthorizationPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI authorization"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Authorization.Screen", desc: componentName)
    }

    // MARK: - Elements

    var loginField: XCEasyUIElement {
        element.child(type: .textField, identifier: "SwiftUIExample.Authorization.LoginField")
    }
    var passwordField: XCEasyUIElement {
        element.child(type: .secureTextField, identifier: "SwiftUIExample.Authorization.PasswordField")
    }
    var submitButton: XCEasyUIElement {
        element.child(type: .button, identifier: "SwiftUIExample.Authorization.SubmitButton")
    }
    var validationErrorContainer: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Authorization.Error")
    }
    var loadingIndicator: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Authorization.Loader")
    }
    var successTitle: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Authorization.SuccessTitle")
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
