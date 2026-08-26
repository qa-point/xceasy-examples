import XCEasy

/// Reusable promo-banner component.
struct UIKitPromoBannerPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit promo banner"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Components.Banner", desc: componentName)
    }

    // MARK: - Elements

    var title: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Banner.Title", desc: "\(componentName): title")
    }
    var closeButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Banner.Close", desc: "\(componentName): close button")
    }

    // MARK: - Actions

    @discardableResult
    func dismiss() -> Self {
        step("Dismiss") { closeButton.tap() }
        return self
    }
}
