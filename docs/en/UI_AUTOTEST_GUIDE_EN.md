# UI-test architecture and Page Objects

English · [Русский](../ru/UI_AUTOTEST_GUIDE_RU.md) · [README](../../README.md)

This guide defines the recommended structure used by both example UI-test targets. The examples
duplicate a small amount of neutral setup deliberately so a reader can understand one target
without first learning a shared infrastructure module.

## 1. Layer boundaries

- A test describes one business scenario through `given`, `when`, `then`, and `and`.
- A Page Object owns screen-specific locators, actions, synchronization, and explicit assertions.
- A component owns one reusable or repeated screen fragment.
- Test-support models contain parameterized input and expected values.
- Test setup contains framework configuration and lifecycle hooks, not business scenarios.

Tests must not call `find(...)`, construct `XCUIElementQuery`, or know accessibility identifiers.
Every UI lookup belongs to a Page Object or component. UIKit and SwiftUI implementations remain
independent; only genuinely neutral infrastructure may be shared in a production project.

## 2. File structure

Keep one feature per test class and one test class per file:

```text
UITests/
├── Core/
│   ├── ExampleTestCase.swift
│   └── PageObjectsProviding.swift
├── Screens/
│   ├── AuthorizationPOM.swift
│   └── ProductCardPOM.swift
├── TestSupport/
│   ├── Models/
│   └── TestSetup/
└── Tests/
    ├── AuthorizationTests.swift
    └── FailureShowcase/
```

Use names that state the screen role. Avoid generic names such as `item`, `page`, or `element` for
domain objects. A test class contains tests only; parameterized case structs belong under
`TestSupport/Models`.

## 3. Page Object layout

Use a consistent order and `MARK` sections: protocol/conformance setup, root element, child
elements/components, actions, and assertions. Put helpers last. Keep computed element declarations
multiline when they perform a lookup.

```swift
struct AuthorizationPOM: XCEasyComponent {
    // MARK: - Component

    let componentName = "Authorization"

    var element: XCEasyUIElement {
        find(identifier: "Authorization.Screen", desc: componentName)
    }

    // MARK: - Elements

    private var loginField: XCEasyUIElement {
        element.child(type: .textField, identifier: "Authorization.Login")
    }

    private var passwordField: XCEasyUIElement {
        element.child(type: .secureTextField, identifier: "Authorization.Password")
    }

    private var submitButton: XCEasyUIElement {
        element.child(type: .button, identifier: "Authorization.Submit")
    }

    // MARK: - Actions

    @discardableResult
    func signIn(login: String, password: String) -> Self {
        step("Fill and submit credentials") {
            loginField.typeText(login)
            passwordField.typeText(password)
            submitButton.tap()
        }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertValidationError(_ message: String) -> Self {
        step("Check validation error") {
            element
                .child(identifier: "Authorization.Error")
                .child(type: .staticText, text: message)
                .assertIsDisplayed()
        }
        return self
    }
}
```

Prefer `element.child(...)` for controls owned by a screen or component. Global lookup is reserved
for system UI such as alerts or the keyboard, and that lookup still belongs in a dedicated POM.
Creating a POM or component must remain lazy and must not resolve the accessibility tree.

Every state-changing POM method returns `Self` and uses `@discardableResult`, even when it is the
only action today. Actions perform interactions; expected outcomes live in tests or explicit
`assert*` methods. Do not combine them into methods such as `loginAndAssertSuccess()`.

## 4. Components and collections

Use `XCEasyComponent` for a reusable fragment and `XCEasyIndexedComponent` with
`XCEasyComponentCollection` for repeated UI. The framework generates readable default names for
first, last, and indexed components, so a POM must not duplicate that naming switch.

```swift
var productCards: XCEasyComponentCollection<ProductCardPOM> {
    .init()
}
```

If a component participates in several assertions, retain its lazy POM in a domain-named local:

```swift
let firstProduct = productCatalog.productCards
    .get(index: 0)

firstProduct.nameLabel
    .assertLabel(value: "Mouse")
firstProduct.detailsLabel
    .assertLabel(value: "$49 · In stock")
```

Do not introduce a local for one simple operation. Keep a direct single call on one line:

```swift
home.openCatalog()
```

## 5. Scenario structure

One test covers one observable scenario and ends with assertions. After the first `then`, use only
additional assertion-oriented `and` steps. A new action after an asserted outcome normally means a
second test case, because an earlier failure would otherwise prevent validation of the later case.

```swift
func testValidCredentialsOpenAccount() {
    given("the authorization screen is open") {
        home.openAuthorization()
        authorization.assertIsDisplayed()
    }

    when("the user signs in with valid credentials") {
        authorization.signIn(login: "admin", password: "password")
    }

    then("the account screen is displayed") {
        account.assertIsReady()
    }
}
```

Avoid `sleep`. Actions already wait for their required state. Use an explicit assertion with a
meaningful timeout for mandatory state, or handle a wait result when the state is genuinely
optional.

## 6. Isolation and lifecycle

- Every test starts a new application and execution-scoped XCEasy context.
- Establish initial state through launch arguments/environment or a deterministic setup API.
- Do not depend on test order, shared mutable singletons, or another test's result.
- Put configuration in `configuration()`, shared metadata/preconditions in `beforeTest()`, and
  cleanup requiring a live application in `afterTest()`.
- Call the corresponding `super` implementation required by XCEasy.
- Do not override XCTest setup/teardown unless infrastructure work genuinely requires it.

The optional runner `app_reset_hook` is an explicit test-only mechanism. It clears approved app
storage without reinstalling the app, but it cannot universally reset iOS privacy permissions.

## 7. Parameterization and metadata

Parameterize multiple datasets for one scenario, not unrelated business flows. Put cases in a
model file and give every case a stable readable ID. Mask or hide passwords and tokens in Allure
parameters.

Markers describe stable selection dimensions such as `Team1`, `Team2`, `Smoke`, a platform, or a
feature area. Owner and lead examples use distinct values such as `Owner1` and `Lead1`. Do not use
markers for temporary status or execution order.

## 8. Soft assertions

Use `softly` for independent properties of one already reached state. Do not mix actions into a
soft-assertion block, and do not continue a scenario when the next action requires those checks to
have succeeded.

## 9. Review checklist

1. Accessibility identifiers are stable and unique in the required scope.
2. Tests contain no direct UI lookup.
3. POM/component construction performs no UI resolution or assertion.
4. Action methods contain no expected-result assertions and return `Self`.
5. Expected results are in `then`/`and` or explicit `assert*` POM methods.
6. Required wait results are not ignored; there are no magic sleeps.
7. Tests are isolated and contain no execution-order dependency.
8. Sensitive metadata parameters are masked or hidden.
9. Each test class owns one feature and lives in its own file.
10. Successful and intentional-failure Allure artifacts are inspected.
11. Both schemes pass the repository check:

```bash
./scripts/check.sh
```

For adjacent framework development set `TUIST_XCEASY_USE_LOCAL_PACKAGE=1`. Use
`./scripts/check-all.sh` only for report review: it intentionally produces the documented
46 passed and 10 failed results in one `allure-results` directory.
