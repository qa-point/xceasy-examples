import XCEasy

@Epic("XCEasy Examples")
@Feature("Failure showcase: list assertions")
@Marker("FailureShowcase")
@Tag("UIKit")
final class UIKitListFailureShowcaseTests: UIKitExampleTestCase {
    @DisplayName("[UIKit][Expected failure] Catalog reports multiple incorrect products")
    @Story("Soft list assertion failures")
    func testCatalogReportsMultipleIncorrectProducts() {
        given("the product catalog is open") {
            home.openCatalog()
        }

        then("multiple intentionally incorrect products are expected") {
            softly("Check intentionally incorrect catalog data") {
                productCatalog.productCards
                    .assertCount(3)
                productCatalog.productCards.first.nameLabel
                    .assertLabel(value: "Trackpad")
                productCatalog.productCards.last.detailsLabel
                    .assertLabel(value: "$1 · In stock")
            }
        }
    }
}
