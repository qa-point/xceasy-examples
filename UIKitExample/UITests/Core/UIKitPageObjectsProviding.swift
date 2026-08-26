/// Provides fresh, lazy UIKit Page Objects to a test case without resolving the UI tree.
protocol UIKitPageObjectsProviding {
    var home: UIKitHomePOM { get }
    var authorization: UIKitAuthorizationPOM { get }
    var componentGallery: UIKitComponentGalleryPOM { get }
    var dynamicContent: UIKitDynamicContentPOM { get }
    var overlays: UIKitOverlaysPOM { get }
    var productCatalog: UIKitProductCatalogPOM { get }
}

extension UIKitPageObjectsProviding {
    var home: UIKitHomePOM { UIKitHomePOM() }
    var authorization: UIKitAuthorizationPOM { UIKitAuthorizationPOM() }
    var componentGallery: UIKitComponentGalleryPOM { UIKitComponentGalleryPOM() }
    var dynamicContent: UIKitDynamicContentPOM { UIKitDynamicContentPOM() }
    var overlays: UIKitOverlaysPOM { UIKitOverlaysPOM() }
    var productCatalog: UIKitProductCatalogPOM { UIKitProductCatalogPOM() }
}
