import XCEasy

/// Page object for the UIKit example home screen.
struct UIKitHomePOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit home"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Home.Screen", desc: componentName)
    }

    // MARK: - Elements

    var title: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.Title", desc: "\(componentName): title")
    }
    var authorizationButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.AuthorizationButton")
    }
    var componentsButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.ComponentsButton")
    }
    var dynamicContentButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.DynamicContentButton")
    }
    var overlaysButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.OverlaysButton")
    }
    var catalogButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Home.CatalogButton")
    }

    // MARK: - Actions

    @discardableResult
    func openAuthorization() -> Self {
        step("Open authorization") { authorizationButton.tap() }
        return self
    }

    @discardableResult
    func openComponents() -> Self {
        step("Open component gallery") { componentsButton.tap() }
        return self
    }

    @discardableResult
    func openDynamicContent() -> Self {
        step("Open dynamic content") { dynamicContentButton.tap() }
        return self
    }

    @discardableResult
    func openOverlays() -> Self {
        step("Open overlays") { overlaysButton.tap() }
        return self
    }

    @discardableResult
    func openCatalog() -> Self {
        step("Open product catalog") { catalogButton.tap() }
        return self
    }

    // MARK: - Assertions

    @discardableResult
    func assertReady() -> Self {
        step("Check feature menu") {
            assertIsDisplayed()
            title.assertLabel(value: "XCEasy UIKit Example")
            authorizationButton.assertIsHittable()
            componentsButton.assertIsHittable()
            dynamicContentButton.assertIsHittable()
            overlaysButton.assertIsHittable()
            catalogButton.assertIsHittable()
        }
        return self
    }
}
