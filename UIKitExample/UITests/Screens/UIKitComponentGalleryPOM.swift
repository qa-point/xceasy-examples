import XCEasy

/// Page object for UIKit controls and reusable components.
struct UIKitComponentGalleryPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit component gallery"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Components.Screen", desc: componentName)
    }

    // MARK: - Elements

    var inputField: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Input")
    }
    var notificationsToggle: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Toggle")
    }
    var termsCheckbox: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Checkbox")
    }
    var firstOptionButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Option.First")
    }
    var secondOptionButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Option.Second")
    }
    var restoreBannerButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Components.Banner.Restore")
    }

    // MARK: - Components

    var banner: UIKitPromoBannerPOM {
        UIKitPromoBannerPOM()
    }

    // MARK: - Component Collections

    let galleryListItems = XCEasyComponentCollection<UIKitGalleryListItemPOM>()
}
