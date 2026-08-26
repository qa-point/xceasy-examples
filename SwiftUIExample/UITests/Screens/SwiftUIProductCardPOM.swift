import XCEasy

/// One lazy product card from the current filtered SwiftUI catalogue.
struct SwiftUIProductCardPOM: XCEasyIndexedComponent {
    // MARK: - XCEasyIndexedComponent

    static var collection: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Catalog.Product", desc: "Products")
    }
    private let position: XCEasyComponentPosition
    let componentName: String

    /// Creates lazy intent for one product at the requested current collection position.
    init(position: XCEasyComponentPosition, componentName: String?) {
        self.position = position
        self.componentName = componentName ?? Self.defaultComponentName(for: position)
    }

    // MARK: - Elements

    var element: XCEasyUIElement {
        Self.collection
            .element(at: position, desc: componentName)
    }

    var nameLabel: XCEasyUIElement {
        element.child(
                type: .staticText,
                identifier: "SwiftUIExample.Catalog.Product.Name",
                desc: "\(componentName): name"
            )
    }

    var detailsLabel: XCEasyUIElement {
        element.child(
                type: .staticText,
                identifier: "SwiftUIExample.Catalog.Product.Details",
                desc: "\(componentName): details"
            )
    }

}
