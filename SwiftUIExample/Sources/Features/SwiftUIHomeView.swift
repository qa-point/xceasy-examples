import SwiftUI

/// Entry screen for manually exploring all SwiftUI demonstration features.
struct SwiftUIHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("XCEasy SwiftUI Example")
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier(SwiftUIIdentifiers.Home.title)

                Text("Choose a feature to inspect its states and the matching XCEasy UI tests.")
                    .foregroundColor(.secondary)

                featureLink("Authorization", subtitle: "Validation, secure input and delayed success", identifier: SwiftUIIdentifiers.Home.authorization) {
                    SwiftUIAuthorizationView()
                }
                featureLink("Component Gallery", subtitle: "Inputs, selections, collections and reusable banners", identifier: SwiftUIIdentifiers.Home.components) {
                    SwiftUIComponentGalleryView()
                }
                featureLink("Dynamic Content", subtitle: "Loading, animations and elements entering or leaving the tree", identifier: SwiftUIIdentifiers.Home.dynamicContent) {
                    SwiftUIDynamicContentView()
                }
                featureLink("Overlays", subtitle: "Alert, sheet and transient toast", identifier: SwiftUIIdentifiers.Home.overlays) {
                    SwiftUIOverlaysView()
                }
                featureLink("Product Catalog", subtitle: "Displayed data, search, sorting and empty state", identifier: SwiftUIIdentifiers.Home.catalog) {
                    SwiftUIProductCatalogView()
                }
            }
            .padding()
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Home.screen)
        .navigationTitle("SwiftUI Example")
    }

    /// Builds one consistently styled navigation card.
    private func featureLink<Destination: View>(
        _ title: String,
        subtitle: String,
        identifier: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: destination()) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }
}

#if DEBUG
struct SwiftUIHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIScreenPreview {
            SwiftUIHomeView()
        }
    }
}
#endif
