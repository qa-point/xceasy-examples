import UIKit
#if DEBUG
import SwiftUI
#endif

/// Entry screen for manually exploring all UIKit demonstration features.
final class UIKitHomeViewController: UIKitStackViewController {
    /// Builds the feature menu and its navigation actions.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Example"
        view.accessibilityIdentifier = UIKitIdentifiers.Home.screen

        let subtitle = UILabel()
        subtitle.text = "Choose a feature to inspect its states and the matching XCEasy UI tests."
        subtitle.numberOfLines = 0
        subtitle.textColor = .secondaryLabel

        contentStack.addArrangedSubview(makeTitle("XCEasy UIKit Example", identifier: UIKitIdentifiers.Home.title))
        contentStack.addArrangedSubview(subtitle)
        addNavigationButton("Authorization", identifier: UIKitIdentifiers.Home.authorization) { UIKitAuthorizationViewController() }
        addNavigationButton("Component Gallery", identifier: UIKitIdentifiers.Home.components) { UIKitScreenViewController() }
        addNavigationButton("Dynamic Content", identifier: UIKitIdentifiers.Home.dynamicContent) { UIKitDynamicContentViewController() }
        addNavigationButton("Overlays", identifier: UIKitIdentifiers.Home.overlays) { UIKitOverlaysViewController() }
        addNavigationButton("Product Catalog", identifier: UIKitIdentifiers.Home.catalog) { UIKitProductCatalogViewController() }
    }

    /// Adds a button that pushes a freshly created feature controller.
    private func addNavigationButton(
        _ title: String,
        identifier: String,
        destination: @escaping () -> UIViewController
    ) {
        let button = makeButton(title, identifier: identifier, action: UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(destination(), animated: true)
        })
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 52).isActive = true
        contentStack.addArrangedSubview(button)
    }
}

#if DEBUG
struct UIKitHomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIKitViewControllerPreview {
            UIKitHomeViewController()
        }
    }
}
#endif
