import XCEasy

/// Page object for UIKit alert, sheet and toast states.
struct UIKitOverlaysPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "UIKit overlays"
    var element: XCEasyUIElement {
        find(identifier: "UIKitExample.Overlays.Screen", desc: componentName)
    }

    // MARK: - Elements

    var showAlertButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Overlays.AlertButton")
    }
    var showSheetButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Overlays.SheetButton")
    }
    var showToastButton: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Overlays.ToastButton")
    }
    var confirmationResultLabel: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Overlays.Result")
    }
    var featureSheet: XCEasyUIElement {
        find(identifier: "UIKitExample.Overlays.Sheet")
    }
    var sheetTitle: XCEasyUIElement {
        featureSheet.child(identifier: "UIKitExample.Overlays.Sheet.Title", desc: "Feature sheet: title")
    }
    var closeSheetButton: XCEasyUIElement {
        featureSheet.child(identifier: "UIKitExample.Overlays.Sheet.Close", desc: "Feature sheet: close button")
    }
    var toastMessage: XCEasyUIElement {
        element.child(identifier: "UIKitExample.Overlays.Toast")
    }

    // MARK: - Components

    var confirmationAlert: UIKitConfirmationAlertPOM {
        UIKitConfirmationAlertPOM()
    }
}
