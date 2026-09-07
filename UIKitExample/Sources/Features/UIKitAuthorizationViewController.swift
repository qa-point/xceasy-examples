import UIKit
#if DEBUG
import SwiftUI
#endif

/// Deterministic mocked authorization flow with positive and negative states.
final class UIKitAuthorizationViewController: UIKitStackViewController {
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let errorContainer = UIStackView()
    private let errorLabel = UILabel()
    private let loader = UIActivityIndicatorView(style: .medium)
    private lazy var submitButton = makeButton(
        "Sign in",
        identifier: UIKitIdentifiers.Authorization.submit,
        action: UIAction { [weak self] _ in self?.submit() }
    )

    /// Configures the authorization form.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Authorization"
        view.accessibilityIdentifier = UIKitIdentifiers.Authorization.screen

        loginField.placeholder = "Login"
        loginField.borderStyle = .roundedRect
        loginField.autocapitalizationType = .none
        loginField.autocorrectionType = .no
        loginField.accessibilityIdentifier = UIKitIdentifiers.Authorization.login

        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.keyboardType = .asciiCapable
        passwordField.accessibilityIdentifier = UIKitIdentifiers.Authorization.password

        errorContainer.axis = .vertical
        errorContainer.isHidden = true
        errorContainer.accessibilityIdentifier = UIKitIdentifiers.Authorization.error

        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.accessibilityIdentifier = UIKitIdentifiers.Authorization.errorMessage
        errorContainer.addArrangedSubview(errorLabel)

        loader.hidesWhenStopped = true
        loader.isAccessibilityElement = true
        loader.accessibilityLabel = "Signing in"
        loader.accessibilityIdentifier = UIKitIdentifiers.Authorization.loader

        contentStack.addArrangedSubview(makeTitle("Authorization", identifier: UIKitIdentifiers.Authorization.title))
        contentStack.addArrangedSubview(loginField)
        contentStack.addArrangedSubview(passwordField)
        contentStack.addArrangedSubview(errorContainer)
        contentStack.addArrangedSubview(submitButton)
        contentStack.addArrangedSubview(loader)
    }

    /// Validates credentials and simulates a three-second backend request.
    private func submit() {
        view.endEditing(true)
        if let message = validationMessage {
            errorLabel.text = message
            errorContainer.isHidden = false
            return
        }

        errorContainer.isHidden = true
        submitButton.isEnabled = false
        loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            loader.stopAnimating()
            navigationController?.pushViewController(UIKitAuthorizationSuccessViewController(), animated: true)
        }
    }

    /// Returns the first deterministic validation error or `nil` for valid credentials.
    private var validationMessage: String? {
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""
        if login.isEmpty { return "Enter your login." }
        if password.isEmpty { return "Enter your password." }
        if login != "admin" || password != "password" { return "Incorrect login or password." }
        return nil
    }
}

#if DEBUG
struct UIKitAuthorizationViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIKitViewControllerPreview {
                UIKitAuthorizationViewController()
            }
            .previewDisplayName("Initial")

            UIKitViewControllerPreview {
                authorizationPreview(state: .validationError)
            }
            .previewDisplayName("Validation Error")

            UIKitViewControllerPreview {
                authorizationPreview(state: .loading)
            }
            .previewDisplayName("Loading")
        }
    }
}
#endif

/// Final screen shown after the mocked authorization request succeeds.
private final class UIKitAuthorizationSuccessViewController: UIViewController {
    /// Builds the success state.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Success"
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = UIKitIdentifiers.Authorization.successScreen

        let label = UILabel()
        label.text = "Authorization successful"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.accessibilityIdentifier = UIKitIdentifiers.Authorization.successTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20)
        ])
    }
}
