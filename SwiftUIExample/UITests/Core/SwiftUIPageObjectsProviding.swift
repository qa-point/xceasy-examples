/// Provides fresh, lazy SwiftUI Page Objects to a test case without resolving the UI tree.
protocol SwiftUIPageObjectsProviding {
    var home: SwiftUIHomePOM { get }
    var authorization: SwiftUIAuthorizationPOM { get }
    var componentGallery: SwiftUIComponentGalleryPOM { get }
    var dynamicContent: SwiftUIDynamicContentPOM { get }
    var overlays: SwiftUIOverlaysPOM { get }
    var productCatalog: SwiftUIProductCatalogPOM { get }
}

extension SwiftUIPageObjectsProviding {
    var home: SwiftUIHomePOM { SwiftUIHomePOM() }
    var authorization: SwiftUIAuthorizationPOM { SwiftUIAuthorizationPOM() }
    var componentGallery: SwiftUIComponentGalleryPOM { SwiftUIComponentGalleryPOM() }
    var dynamicContent: SwiftUIDynamicContentPOM { SwiftUIDynamicContentPOM() }
    var overlays: SwiftUIOverlaysPOM { SwiftUIOverlaysPOM() }
    var productCatalog: SwiftUIProductCatalogPOM { SwiftUIProductCatalogPOM() }
}
