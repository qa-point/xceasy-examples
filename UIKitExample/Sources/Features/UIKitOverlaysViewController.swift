import UIKit

/// Demonstrates system and custom overlay lifecycles.
final class UIKitOverlaysViewController: UIKitStackViewController {
    private let resultLabel = UILabel()
    private var toastLabel: UILabel?

    /// Builds controls for alert, sheet and toast examples.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Overlays"
        view.accessibilityIdentifier = UIKitIdentifiers.Overlays.screen
        resultLabel.text = "No action selected"
        resultLabel.accessibilityIdentifier = UIKitIdentifiers.Overlays.result

        contentStack.addArrangedSubview(makeTitle("Overlays"))
        contentStack.addArrangedSubview(makeButton(
            "Show confirmation alert",
            identifier: UIKitIdentifiers.Overlays.alert,
            action: UIAction { [weak self] _ in self?.showAlert() }
        ))
        contentStack.addArrangedSubview(makeButton(
            "Open bottom sheet",
            identifier: UIKitIdentifiers.Overlays.sheet,
            action: UIAction { [weak self] _ in self?.showSheet() }
        ))
        contentStack.addArrangedSubview(makeButton(
            "Show toast",
            identifier: UIKitIdentifiers.Overlays.toast,
            action: UIAction { [weak self] _ in self?.showToast() }
        ))
        contentStack.addArrangedSubview(resultLabel)
    }

    /// Presents a deterministic confirmation alert.
    private func showAlert() {
        let alert = UIAlertController(
            title: "Confirm action",
            message: "This is a deterministic mocked confirmation.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.resultLabel.text = "Action cancelled"
        })
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            self?.resultLabel.text = "Action confirmed"
        })
        present(alert, animated: true)
    }

    /// Presents a page sheet with its own accessibility hierarchy.
    private func showSheet() {
        let sheet = UIKitSheetViewController()
        sheet.modalPresentationStyle = .pageSheet
        present(sheet, animated: true)
    }

    /// Shows a toast and removes it from the tree after four seconds.
    private func showToast() {
        toastLabel?.removeFromSuperview()
        let label = UILabel()
        label.text = "Settings saved"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.layer.cornerRadius = 18
        label.clipsToBounds = true
        label.alpha = 0
        label.accessibilityIdentifier = UIKitIdentifiers.Overlays.toastMessage
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        toastLabel = label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        UIView.animate(withDuration: 0.25) { label.alpha = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self, weak label] in
            UIView.animate(withDuration: 0.25, animations: { label?.alpha = 0 }) { _ in
                label?.removeFromSuperview()
                self?.toastLabel = nil
            }
        }
    }
}

/// Content of the UIKit bottom sheet.
private final class UIKitSheetViewController: UIViewController {
    /// Builds the sheet content and close action.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = UIKitIdentifiers.Overlays.sheetContainer

        let title = UILabel()
        title.text = "Feature details"
        title.font = .boldSystemFont(ofSize: 26)
        title.accessibilityIdentifier = UIKitIdentifiers.Overlays.sheetTitle

        var configuration = UIButton.Configuration.filled()
        configuration.title = "Close"
        let close = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })
        close.accessibilityIdentifier = UIKitIdentifiers.Overlays.sheetClose

        let stack = UIStackView(arrangedSubviews: [title, close])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
