import UIKit
#if DEBUG
import SwiftUI
#endif

/// Demonstrates delayed loading, animation, visibility changes and tree removal.
final class UIKitDynamicContentViewController: UIKitStackViewController {
    private let loader = UIActivityIndicatorView(style: .medium)
    private var cardView: UIStackView?
    private var detailsLabel: UILabel?
    private var detailsButton: UIButton?

    /// Builds the initial dynamic-content controls.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dynamic Content"
        view.accessibilityIdentifier = UIKitIdentifiers.DynamicContent.screen
        loader.hidesWhenStopped = true
        loader.accessibilityIdentifier = UIKitIdentifiers.DynamicContent.loader

        contentStack.addArrangedSubview(makeTitle("Dynamic Content"))
        contentStack.addArrangedSubview(makeButton(
            "Load recommendation",
            identifier: UIKitIdentifiers.DynamicContent.load,
            action: UIAction { [weak self] _ in self?.loadCard() }
        ))
        contentStack.addArrangedSubview(loader)
        contentStack.addArrangedSubview(makeButton(
            "Restore immediately",
            identifier: UIKitIdentifiers.DynamicContent.restore,
            action: UIAction { [weak self] _ in self?.showCard(animated: true) }
        ))
    }

    /// Shows a loader and inserts a card after a deterministic delay.
    private func loadCard() {
        removeCard(animated: false)
        loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.loader.stopAnimating()
            self?.showCard(animated: true)
        }
    }

    /// Inserts the recommendation card if it is not already present.
    private func showCard(animated: Bool) {
        guard cardView == nil else { return }

        let title = UILabel()
        title.text = "Recommended plan"
        title.font = .boldSystemFont(ofSize: 18)
        title.accessibilityIdentifier = UIKitIdentifiers.DynamicContent.cardTitle

        let toggle = makeButton(
            "Show details",
            identifier: UIKitIdentifiers.DynamicContent.toggleDetails,
            action: UIAction { [weak self] _ in self?.toggleDetails() }
        )
        detailsButton = toggle
        let remove = makeButton(
            "Remove card",
            identifier: UIKitIdentifiers.DynamicContent.remove,
            action: UIAction { [weak self] _ in self?.removeCard(animated: true) }
        )
        remove.configuration?.baseBackgroundColor = .systemRed

        let card = UIStackView(arrangedSubviews: [title, toggle, remove])
        card.axis = .vertical
        card.spacing = 12
        card.isLayoutMarginsRelativeArrangement = true
        card.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        card.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        card.layer.cornerRadius = 12
        card.accessibilityIdentifier = UIKitIdentifiers.DynamicContent.card
        card.alpha = animated ? 0 : 1
        contentStack.addArrangedSubview(card)
        cardView = card

        if animated {
            UIView.animate(withDuration: 0.35) { card.alpha = 1 }
        }
    }

    /// Toggles an animated details label within the current card.
    private func toggleDetails() {
        guard let cardView else { return }
        if let detailsLabel {
            UIView.animate(withDuration: 0.25, animations: { detailsLabel.alpha = 0 }) { [weak self] _ in
                cardView.removeArrangedSubview(detailsLabel)
                detailsLabel.removeFromSuperview()
                self?.detailsLabel = nil
                self?.detailsButton?.configuration?.title = "Show details"
            }
            return
        }

        let label = UILabel()
        label.text = "Includes diagnostics, performance metrics and AI-ready logs."
        label.numberOfLines = 0
        label.alpha = 0
        label.accessibilityIdentifier = UIKitIdentifiers.DynamicContent.details
        cardView.insertArrangedSubview(label, at: 2)
        detailsLabel = label
        detailsButton?.configuration?.title = "Hide details"
        UIView.animate(withDuration: 0.25) { label.alpha = 1 }
    }

    /// Removes the card from both the arranged stack and accessibility tree.
    private func removeCard(animated: Bool) {
        guard let cardView else { return }
        let completion: (Bool) -> Void = { [weak self] _ in
            self?.contentStack.removeArrangedSubview(cardView)
            cardView.removeFromSuperview()
            self?.cardView = nil
            self?.detailsLabel = nil
            self?.detailsButton = nil
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: { cardView.alpha = 0 }, completion: completion)
        } else {
            completion(true)
        }
    }
}

#if DEBUG
struct UIKitDynamicContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIKitViewControllerPreview {
                UIKitDynamicContentViewController()
            }
            .previewDisplayName("Initial")

            UIKitViewControllerPreview {
                dynamicContentPreview(state: .loading)
            }
            .previewDisplayName("Loading")

            UIKitViewControllerPreview {
                dynamicContentPreview(state: .expandedCard)
            }
            .previewDisplayName("Expanded Card")
        }
    }
}
#endif
