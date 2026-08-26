import SwiftUI

/// Searchable deterministic data catalogue used for content assertions.
struct SwiftUIProductCatalogView: View {
    private struct Product: Identifiable {
        let name: String
        let price: Int
        let available: Bool
        var id: String { name }
    }

    private let products = [
        Product(name: "Keyboard", price: 99, available: true),
        Product(name: "Monitor", price: 399, available: false),
        Product(name: "Mouse", price: 49, available: true),
        Product(name: "Laptop Stand", price: 79, available: true)
    ]

    @State private var query = ""
    @State private var ascending = true

    var body: some View {
        VStack(spacing: 12) {
            Text("Product Catalog")
                .font(.largeTitle.bold())

            TextField("Search products", text: $query)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.search)

            Button(ascending ? "Sort: low to high" : "Sort: high to low") {
                ascending.toggle()
            }
            .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.sort)

            if filteredProducts.isEmpty {
                Text("No products found")
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.empty)
            } else {
                List(filteredProducts) { product in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.headline)
                            .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.productName)
                        Text("$\(product.price) · \(product.available ? "In stock" : "Out of stock")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.productDetails)
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.product)
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Catalog.screen)
        .navigationTitle("Product Catalog")
    }

    /// Applies case-insensitive filtering and the selected price ordering.
    private var filteredProducts: [Product] {
        products
            .filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
            .sorted { ascending ? $0.price < $1.price : $0.price > $1.price }
    }
}
