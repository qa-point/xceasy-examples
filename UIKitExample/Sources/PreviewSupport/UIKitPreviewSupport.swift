import SwiftUI
import UIKit

#if DEBUG
/// Wraps feature controllers in the navigation context used by the application.
struct UIKitViewControllerPreview: UIViewControllerRepresentable {
    let makeViewController: () -> UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: makeViewController())
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {}
}

enum UIKitAuthorizationPreviewState {
    case validationError
    case loading
}

enum UIKitDynamicContentPreviewState {
    case loading
    case expandedCard
}

/// Configures deterministic UIKit screen states without changing production APIs.
func authorizationPreview(
    state: UIKitAuthorizationPreviewState
) -> UIViewController {
    let viewController = UIKitAuthorizationViewController()
    viewController.loadViewIfNeeded()

    switch state {
    case .validationError:
        let errorContainer: UIStackView? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.Authorization.error
        )
        let errorLabel: UILabel? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.Authorization.errorMessage
        )
        errorLabel?.text = "Incorrect login or password."
        errorContainer?.isHidden = false
    case .loading:
        let submitButton: UIButton? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.Authorization.submit
        )
        let loader: UIActivityIndicatorView? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.Authorization.loader
        )
        submitButton?.isEnabled = false
        loader?.startAnimating()
    }

    return viewController
}

func dynamicContentPreview(
    state: UIKitDynamicContentPreviewState
) -> UIViewController {
    let viewController = UIKitDynamicContentViewController()
    viewController.loadViewIfNeeded()

    switch state {
    case .loading:
        let loader: UIActivityIndicatorView? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.DynamicContent.loader
        )
        loader?.startAnimating()
    case .expandedCard:
        let restoreButton: UIButton? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.DynamicContent.restore
        )
        restoreButton?.sendActions(for: .primaryActionTriggered)

        let detailsButton: UIButton? = viewController.view.previewSubview(
            identifier: UIKitIdentifiers.DynamicContent.toggleDetails
        )
        detailsButton?.sendActions(for: .primaryActionTriggered)
    }

    return viewController
}

func emptyCatalogPreview() -> UIViewController {
    let viewController = UIKitProductCatalogViewController()
    viewController.loadViewIfNeeded()
    let searchField: UITextField? = viewController.view.previewSubview(
        identifier: UIKitIdentifiers.Catalog.search
    )
    searchField?.text = "missing product"
    searchField?.sendActions(for: .editingChanged)
    return viewController
}

/// Gives a UIKit view a SwiftUI-compatible preview surface.
struct UIKitViewPreview: UIViewRepresentable {
    let makeView: () -> UIView

    func makeUIView(context: Context) -> UIView {
        makeView()
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

func promoBannerPreview(generation: Int) -> UIView {
    let container = UIView()
    container.backgroundColor = .systemBackground

    let banner = UIKitPromoBannerView(generation: generation)
    banner.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(banner)

    NSLayoutConstraint.activate([
        banner.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        banner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
        banner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
    ])

    return container
}

private extension UIView {
    func previewSubview<View: UIView>(
        identifier: String,
        as type: View.Type = View.self
    ) -> View? {
        if accessibilityIdentifier == identifier, let matchingView = self as? View {
            return matchingView
        }

        for subview in subviews {
            if let matchingView = subview.previewSubview(identifier: identifier, as: type) {
                return matchingView
            }
        }

        return nil
    }
}
#endif
