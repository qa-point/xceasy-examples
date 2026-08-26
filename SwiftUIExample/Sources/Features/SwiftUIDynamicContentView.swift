import SwiftUI

/// Demonstrates delayed loading, animation, visibility changes and tree removal.
struct SwiftUIDynamicContentView: View {
    @State private var isLoading = false
    @State private var isCardPresented = false
    @State private var areDetailsPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dynamic Content")
                .font(.largeTitle.bold())

            Button("Load recommendation", action: loadCard)
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.load)

            if isLoading {
                ProgressView("Loading recommendation…")
                    .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.loader)
            }

            if isCardPresented {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommended plan")
                        .font(.headline)
                        .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.cardTitle)

                    Button(areDetailsPresented ? "Hide details" : "Show details") {
                        withAnimation { areDetailsPresented.toggle() }
                    }
                    .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.toggleDetails)

                    if areDetailsPresented {
                        Text("Includes diagnostics, performance metrics and AI-ready logs.")
                            .transition(.opacity.combined(with: .slide))
                            .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.details)
                    }

                    Button("Remove card", role: .destructive) {
                        withAnimation {
                            isCardPresented = false
                            areDetailsPresented = false
                        }
                    }
                    .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.remove)
                }
                .padding()
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.scale.combined(with: .opacity))
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.card)
            } else if !isLoading {
                Button("Restore immediately") {
                    withAnimation { isCardPresented = true }
                }
                .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.restore)
            }

            Spacer()
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.DynamicContent.screen)
        .navigationTitle("Dynamic Content")
    }

    /// Shows a loader and inserts a card after a deterministic delay.
    private func loadCard() {
        isCardPresented = false
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
                isCardPresented = true
            }
        }
    }
}
