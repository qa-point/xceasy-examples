import XCEasy

/// Page object for delayed and animated SwiftUI content.
struct SwiftUIDynamicContentPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI dynamic content"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Dynamic.Screen", desc: componentName)
    }

    // MARK: - Elements

    var loadContentButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Dynamic.LoadButton")
    }
    var loadingIndicator: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Dynamic.Loader")
    }
    var recommendationCard: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Dynamic.Card", desc: "Recommendation card")
    }
    var recommendationTitle: XCEasyUIElement {
        recommendationCard.child(identifier: "SwiftUIExample.Dynamic.Card.Title", desc: "Recommendation card: title")
    }
    var recommendationDetails: XCEasyUIElement {
        recommendationCard.child(identifier: "SwiftUIExample.Dynamic.Card.Details", desc: "Recommendation card: details")
    }
    var toggleDetailsButton: XCEasyUIElement {
        recommendationCard.child(identifier: "SwiftUIExample.Dynamic.ToggleDetailsButton", desc: "Recommendation card: details button")
    }
    var removeRecommendationButton: XCEasyUIElement {
        recommendationCard.child(identifier: "SwiftUIExample.Dynamic.RemoveButton", desc: "Recommendation card: remove button")
    }
    var restoreRecommendationButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Dynamic.RestoreButton")
    }
}
