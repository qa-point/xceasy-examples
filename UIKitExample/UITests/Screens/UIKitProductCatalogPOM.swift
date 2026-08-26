import XCEasy

/// Page object for searchable UIKit product data.
struct UIKitProductCatalogPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit product catalog"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Catalog.Screen", desc: componentName)
    }

    // MARK: - Elements

    var searchField: XCEasyUIElement {
        element.child(type: .textField, identifier: "UIKitExample.Catalog.SearchField")
    }
    var sortButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Catalog.SortButton")
    }
    var emptyState: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Catalog.EmptyState")
    }

    // MARK: - Component Collections

    let productCards = XCEasyComponentCollection<UIKitProductCardPOM>()
}
