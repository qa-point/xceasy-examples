import UIKit
#if DEBUG
import SwiftUI
#endif

/// Searchable deterministic data catalogue used for content assertions.
final class UIKitProductCatalogViewController: UIKitStackViewController {
    private struct Product {
        let name: String
        let price: Int
        let available: Bool
    }

    private let products = [
        Product(name: "Keyboard", price: 99, available: true),
        Product(name: "Monitor", price: 399, available: false),
        Product(name: "Mouse", price: 49, available: true),
        Product(name: "Laptop Stand", price: 79, available: true)
    ]
    private let searchField = UITextField()
    private let productsStack = UIStackView()
    private var ascending = true
    private lazy var sortButton = makeButton(
        "Sort: low to high",
        identifier: UIKitIdentifiers.Catalog.sort,
        action: UIAction { [weak self] _ in self?.toggleSort() }
    )

    /// Builds search, sorting and product list controls.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Catalog"
        view.accessibilityIdentifier = UIKitIdentifiers.Catalog.screen

        searchField.placeholder = "Search products"
        searchField.borderStyle = .roundedRect
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.accessibilityIdentifier = UIKitIdentifiers.Catalog.search
        searchField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)

        productsStack.axis = .vertical
        productsStack.spacing = 10

        contentStack.addArrangedSubview(makeTitle("Product Catalog"))
        contentStack.addArrangedSubview(searchField)
        contentStack.addArrangedSubview(sortButton)
        contentStack.addArrangedSubview(productsStack)
        renderProducts()
    }

    /// Re-renders products after a search field edit.
    @objc private func searchChanged() {
        renderProducts()
    }

    /// Changes price ordering and updates the button title.
    private func toggleSort() {
        ascending.toggle()
        sortButton.configuration?.title = ascending ? "Sort: low to high" : "Sort: high to low"
        renderProducts()
    }

    /// Rebuilds the visible product cells from current filter and ordering state.
    private func renderProducts() {
        productsStack.arrangedSubviews.forEach {
            productsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let query = searchField.text ?? ""
        let visibleProducts = products
            .filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
            .sorted { ascending ? $0.price < $1.price : $0.price > $1.price }

        guard !visibleProducts.isEmpty else {
            let empty = UILabel()
            empty.text = "No products found"
            empty.textColor = .secondaryLabel
            empty.accessibilityIdentifier = UIKitIdentifiers.Catalog.empty
            productsStack.addArrangedSubview(empty)
            return
        }

        for product in visibleProducts {
            let name = UILabel()
            name.text = product.name
            name.font = .boldSystemFont(ofSize: 17)
            name.accessibilityIdentifier = UIKitIdentifiers.Catalog.productName

            let details = UILabel()
            details.text = "$\(product.price) · \(product.available ? "In stock" : "Out of stock")"
            details.textColor = .secondaryLabel
            details.accessibilityIdentifier = UIKitIdentifiers.Catalog.productDetails

            let cell = UIStackView(arrangedSubviews: [name, details])
            cell.axis = .vertical
            cell.spacing = 4
            cell.isLayoutMarginsRelativeArrangement = true
            cell.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            cell.backgroundColor = UIColor.secondarySystemBackground
            cell.layer.cornerRadius = 8
            cell.accessibilityIdentifier = UIKitIdentifiers.Catalog.product
            cell.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
            productsStack.addArrangedSubview(cell)
        }
    }
}

#if DEBUG
struct UIKitProductCatalogViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIKitViewControllerPreview {
                UIKitProductCatalogViewController()
            }
            .previewDisplayName("Populated")

            UIKitViewControllerPreview {
                emptyCatalogPreview()
            }
            .previewDisplayName("Empty")
        }
    }
}
#endif
