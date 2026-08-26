import XCEasy

/// One lazy item in the repeated component-gallery collection.
struct SwiftUIGalleryListItemPOM: XCEasyIndexedComponent {
    // MARK: - XCEasyIndexedComponent

    static var collection: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Components.ListItem", desc: "Gallery items")
    }
    private let position: XCEasyComponentPosition
    let componentName: String

    init(position: XCEasyComponentPosition, componentName: String?) {
        self.position = position
        self.componentName = componentName ?? Self.defaultComponentName(for: position)
    }

    var element: XCEasyUIElement {
        Self.collection
            .element(at: position, desc: componentName)
    }
}
