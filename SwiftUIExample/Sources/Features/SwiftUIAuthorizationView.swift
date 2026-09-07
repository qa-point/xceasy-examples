import SwiftUI

/// Deterministic mocked authorization flow with positive and negative states.
struct SwiftUIAuthorizationView: View {
    @State private var login = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var isAuthorized = false

#if DEBUG
    enum PreviewState {
        case initial
        case validationError
        case loading
    }

    init(previewState: PreviewState = .initial) {
        switch previewState {
        case .initial:
            break
        case .validationError:
            _login = State(initialValue: "admin")
            _password = State(initialValue: "wrong-password")
            _errorMessage = State(initialValue: "Incorrect login or password.")
        case .loading:
            _login = State(initialValue: "admin")
            _password = State(initialValue: "password")
            _isLoading = State(initialValue: true)
        }
    }
#endif

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Authorization")
                .font(.largeTitle.bold())
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.title)

            Text("Use admin / password for a successful mocked login.")
                .foregroundColor(.secondary)

            TextField("Login", text: $login)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.login)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.asciiCapable)
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.password)

            if let errorMessage {
                VStack(alignment: .leading) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.errorMessage)
                }
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.error)
            }

            Button("Sign in", action: submit)
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.submit)

            if isLoading {
                ProgressView("Signing in…")
                    .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.loader)
            }

            NavigationLink(isActive: $isAuthorized) {
                SwiftUIAuthorizationSuccessView()
            } label: {
                EmptyView()
            }

            Spacer()
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.screen)
        .navigationTitle("Authorization")
    }

    /// Validates credentials and simulates a three-second backend request.
    private func submit() {
        errorMessage = validationMessage
        guard errorMessage == nil else { return }

        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
            isAuthorized = true
        }
    }

    /// Returns the first deterministic validation error or `nil` for valid credentials.
    private var validationMessage: String? {
        if login.isEmpty { return "Enter your login." }
        if password.isEmpty { return "Enter your password." }
        if login != "admin" || password != "password" { return "Incorrect login or password." }
        return nil
    }
}

/// Final screen shown after the mocked authorization request succeeds.
private struct SwiftUIAuthorizationSuccessView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.green)
            Text("Authorization successful")
                .font(.title.bold())
                .accessibilityIdentifier(SwiftUIIdentifiers.Authorization.successTitle)
        }
        .navigationTitle("Success")
    }
}

#if DEBUG
struct SwiftUIAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftUIScreenPreview {
                SwiftUIAuthorizationView()
            }
            .previewDisplayName("Initial")

            SwiftUIScreenPreview {
                SwiftUIAuthorizationView(previewState: .validationError)
            }
            .previewDisplayName("Validation Error")

            SwiftUIScreenPreview {
                SwiftUIAuthorizationView(previewState: .loading)
            }
            .previewDisplayName("Loading")
        }
    }
}
#endif
