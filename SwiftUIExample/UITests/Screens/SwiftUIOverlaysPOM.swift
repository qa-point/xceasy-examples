import XCEasy

/// Page object for SwiftUI alert, sheet and toast states.
struct SwiftUIOverlaysPOM: XCEasyComponent {
    // MARK: - XCEasyComponent

    let componentName = "SwiftUI overlays"
    var element: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Overlays.Screen", desc: componentName)
    }

    // MARK: - Elements

    var showAlertButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Overlays.AlertButton")
    }
    var showSheetButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Overlays.SheetButton")
    }
    var showToastButton: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Overlays.ToastButton")
    }
    var confirmationResultLabel: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Overlays.Result")
    }
    var featureSheet: XCEasyUIElement {
        find(identifier: "SwiftUIExample.Overlays.Sheet")
    }
    var sheetTitle: XCEasyUIElement {
        featureSheet.child(identifier: "SwiftUIExample.Overlays.Sheet.Title", desc: "Feature sheet: title")
    }
    var closeSheetButton: XCEasyUIElement {
        featureSheet.child(identifier: "SwiftUIExample.Overlays.Sheet.Close", desc: "Feature sheet: close button")
    }
    var toastMessage: XCEasyUIElement {
        element.child(identifier: "SwiftUIExample.Overlays.Toast")
    }

    // MARK: - Components

    var confirmationAlert: SwiftUIConfirmationAlertPOM {
        SwiftUIConfirmationAlertPOM()
    }
}
