import XCEasy

@Epic("XCEasy Examples")
@Feature("Authorization")
@Marker("SwiftUI")
final class SwiftUIAuthorizationTests: SwiftUIExampleTestCase {
    @DisplayName("[SwiftUI] Authorization validation: {id}")
    @Story("Authorization validation")
    @ParameterizedTest(
        name: "[{index}] SwiftUI authorization {id}",
        cases: [
            AuthorizationTestData(id: "empty-login", login: "", password: "password", expectedError: "Enter your login."),
            AuthorizationTestData(id: "empty-password", login: "admin", password: "", expectedError: "Enter your password."),
            AuthorizationTestData(id: "invalid-credentials", login: "guest", password: "wrong", expectedError: "Incorrect login or password.")
        ]
    )
    private func authorizationValidation(_ data: AuthorizationTestData) {
        parameter("login", value: data.login.isEmpty ? "<empty>" : data.login)
        parameter("password", value: data.password.isEmpty ? "<empty>" : data.password, mode: .masked)

        given("the authorization screen is open") {
            home.openAuthorization()
        }

        when("the user submits the provided credentials") {
            authorization.signIn(login: data.login, password: data.password)
        }

        then("the expected validation error is displayed") {
            authorization.assertError(data.expectedError)
        }
    }

    @DisplayName("[SwiftUI] Successful authorization")
    @Story("Authorization success")
    func testSuccessfulAuthorizationShowsLoaderAndSuccessScreen() {
        given("the authorization screen is open") {
            home.openAuthorization()
        }

        when("the user submits valid credentials") {
            authorization.signIn(login: "admin", password: "password")
        }

        then("the loading indicator is displayed") {
            authorization.loadingIndicator
                .assertIsDisplayed(timeout: 1)
        }

        and("the success screen is opened") {
            authorization.successTitle
                .assertLabel(value: "Authorization successful", timeout: 5)
        }

        and("the loading indicator is removed") {
            authorization.loadingIndicator
                .assertDoesNotExist(timeout: 1)
        }
    }
}
