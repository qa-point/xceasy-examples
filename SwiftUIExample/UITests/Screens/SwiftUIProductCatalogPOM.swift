import XCEasy

/// Page object for searchable SwiftUI product data.
struct SwiftUIProductCatalogPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI product catalog"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Catalog.Screen", desc: componentName)
    }

    // MARK: - Elements

    var searchField: XCEasyUIElement {
        element.child(type: .textField, identifier: "SwiftUIExample.Catalog.SearchField")
    }
    var sortButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Catalog.SortButton")
    }
    var emptyState: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Catalog.EmptyState")
    }

    // MARK: - Component Collections

    let productCards = XCEasyComponentCollection<SwiftUIProductCardPOM>()
}
