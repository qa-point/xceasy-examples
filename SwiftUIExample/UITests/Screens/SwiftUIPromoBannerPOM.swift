import XCEasy

/// Reusable promo-banner component.
struct SwiftUIPromoBannerPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI promo banner"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Components.Banner", desc: componentName)
    }

    // MARK: - Elements

    var title: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Banner.Title", desc: "\(componentName): title")
    }
    var closeButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Banner.Close", desc: "\(componentName): close button")
    }

    // MARK: - Actions

    @discardableResult
    func dismiss() -> Self {
        step("Dismiss") { closeButton.tap() }
        return self
    }
}
