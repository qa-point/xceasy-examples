import XCEasy

@Epic("XCEasy Examples")
@Feature("Catalog")
@Marker("UIKit")
final class UIKitCatalogTests: UIKitExampleTestCase {
    @DisplayName("[UIKit] Catalog sorts products by ascending price")
    @Story("Product sorting")
    func testCatalogDisplaysProductsSortedFromLowestToHighestPrice() {
        given("the product catalog is open") {
            home.openCatalog()
        }

        then("the catalog contains four products") {
            productCatalog.productCards
                .assertCount(4)
            productCatalog.productCards
                .assertIsNotEmpty()
        }

        and("the products are sorted from lowest to highest price") {
            let firstProduct = productCatalog.productCards
                .get(index: 0)
            let secondProduct = productCatalog.productCards
                .get(index: 1)
            let thirdProduct = productCatalog.productCards
                .get(index: 2)
            let fourthProduct = productCatalog.productCards
                .get(index: 3)

            firstProduct.nameLabel
                .assertLabel(value: "Mouse")
            firstProduct.detailsLabel
                .assertLabel(value: "$49 · In stock")
            secondProduct.nameLabel
                .assertLabel(value: "Laptop Stand")
            thirdProduct.nameLabel
                .assertLabel(value: "Keyboard")
            fourthProduct.nameLabel
                .assertLabel(value: "Monitor")
            fourthProduct.detailsLabel
                .assertLabel(value: "$399 · Out of stock")
        }
    }

    @DisplayName("[UIKit] Catalog sorts products by descending price")
    @Story("Product sorting")
    func testCatalogSortsProductsFromHighestToLowestPrice() {
        given("the product catalog is open") {
            home.openCatalog()
        }

        when("the user changes sorting to high-to-low") {
            productCatalog.sortButton
                .tap()
        }

        then("the products are sorted from highest to lowest price") {
            let firstProduct = productCatalog.productCards
                .get(index: 0)
            let secondProduct = productCatalog.productCards
                .get(index: 1)
            let thirdProduct = productCatalog.productCards
                .get(index: 2)
            let fourthProduct = productCatalog.productCards
                .get(index: 3)

            productCatalog.sortButton
                .assertLabel(value: "Sort: high to low")
            firstProduct.nameLabel
                .assertLabel(value: "Monitor")
            secondProduct.nameLabel
                .assertLabel(value: "Keyboard")
            thirdProduct.nameLabel
                .assertLabel(value: "Laptop Stand")
            fourthProduct.nameLabel
                .assertLabel(value: "Mouse")
        }
    }

    @DisplayName("[UIKit] Catalog filters products by search query")
    @Story("Product search")
    func testCatalogFiltersProductsBySearchQuery() {
        given("the product catalog is open") {
            home.openCatalog()
        }

        when("the user searches for Mouse") {
            productCatalog.searchField
                .typeText("Mouse")
        }

        then("the matching product and its data are displayed") {
            let matchingProduct = productCatalog.productCards
                .get(index: 0)

            productCatalog.productCards
                .assertCount(1)
            matchingProduct.nameLabel
                .assertLabel(value: "Mouse")
            matchingProduct.detailsLabel
                .assertLabel(value: "$49 · In stock")
        }
    }

    @DisplayName("[UIKit] Catalog shows an empty state for a missing product")
    @Story("Product search")
    func testCatalogDisplaysEmptyStateForMissingProduct() {
        given("the product catalog is open") {
            home.openCatalog()
        }

        when("the user searches for a missing product") {
            productCatalog.searchField
                .typeText("missing product")
        }

        then("the catalog displays its empty state") {
            productCatalog.emptyState
                .assertLabel(value: "No products found")
            productCatalog.productCards
                .assertIsEmpty()
        }
    }
}
