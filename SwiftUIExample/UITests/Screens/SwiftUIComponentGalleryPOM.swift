import XCEasy

/// Page object for SwiftUI controls and reusable components.
struct SwiftUIComponentGalleryPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI component gallery"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Components.Screen", desc: componentName)
    }

    // MARK: - Elements

    var inputField: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Input")
    }
    var notificationsToggle: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Toggle")
    }
    var termsCheckbox: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Checkbox")
    }
    var firstOptionButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Option.First")
    }
    var secondOptionButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Option.Second")
    }
    var restoreBannerButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Components.Banner.Restore")
    }

    // MARK: - Components

    var banner: SwiftUIPromoBannerPOM {
        SwiftUIPromoBannerPOM()
    }

    // MARK: - Component Collections

    let galleryListItems = XCEasyComponentCollection<SwiftUIGalleryListItemPOM>()
}
