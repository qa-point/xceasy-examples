import XCEasy

/// Page object for delayed and animated UIKit content.
struct UIKitDynamicContentPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit dynamic content"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Dynamic.Screen", desc: componentName)
    }

    // MARK: - Elements

    var loadContentButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Dynamic.LoadButton")
    }
    var loadingIndicator: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Dynamic.Loader")
    }
    var recommendationCard: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Dynamic.Card", desc: "Recommendation card")
    }
    var recommendationTitle: XCEasyUIElement {
        recommendationCard.child(identifier: "UIKitExample.Dynamic.Card.Title", desc: "Recommendation card: title")
    }
    var recommendationDetails: XCEasyUIElement {
        recommendationCard.child(identifier: "UIKitExample.Dynamic.Card.Details", desc: "Recommendation card: details")
    }
    var toggleDetailsButton: XCEasyUIElement {
        recommendationCard.child(identifier: "UIKitExample.Dynamic.ToggleDetailsButton", desc: "Recommendation card: details button")
    }
    var removeRecommendationButton: XCEasyUIElement {
        recommendationCard.child(identifier: "UIKitExample.Dynamic.RemoveButton", desc: "Recommendation card: remove button")
    }
    var restoreRecommendationButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Dynamic.RestoreButton")
    }
}
