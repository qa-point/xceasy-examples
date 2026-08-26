import Foundation

/// Stable accessibility identifiers owned exclusively by the SwiftUI example.
enum SwiftUIIdentifiers {
    static let prefix = "SwiftUIExample"

    enum Home {
        static let screen = "\(prefix).Home.Screen"
        static let title = "\(prefix).Home.Title"
        static let authorization = "\(prefix).Home.AuthorizationButton"
        static let components = "\(prefix).Home.ComponentsButton"
        static let dynamicContent = "\(prefix).Home.DynamicContentButton"
        static let overlays = "\(prefix).Home.OverlaysButton"
        static let catalog = "\(prefix).Home.CatalogButton"
    }

    enum Authorization {
        static let screen = "\(prefix).Authorization.Screen"
        static let title = "\(prefix).Authorization.Title"
        static let login = "\(prefix).Authorization.LoginField"
        static let password = "\(prefix).Authorization.PasswordField"
        static let submit = "\(prefix).Authorization.SubmitButton"
        static let error = "\(prefix).Authorization.Error"
        static let errorMessage = "\(prefix).Authorization.Error.Message"
        static let loader = "\(prefix).Authorization.Loader"
        static let successScreen = "\(prefix).Authorization.SuccessScreen"
        static let successTitle = "\(prefix).Authorization.SuccessTitle"
    }

    enum Components {
        static let screen = "\(prefix).Components.Screen"
        static let input = "\(prefix).Components.Input"
        static let toggle = "\(prefix).Components.Toggle"
        static let checkbox = "\(prefix).Components.Checkbox"
        static let firstOption = "\(prefix).Components.Option.First"
        static let secondOption = "\(prefix).Components.Option.Second"
        static let banner = "\(prefix).Components.Banner"
        static let bannerTitle = "\(prefix).Components.Banner.Title"
        static let bannerClose = "\(prefix).Components.Banner.Close"
        static let bannerRestore = "\(prefix).Components.Banner.Restore"
        static let listItem = "\(prefix).Components.ListItem"
    }

    enum DynamicContent {
        static let screen = "\(prefix).Dynamic.Screen"
        static let load = "\(prefix).Dynamic.LoadButton"
        static let loader = "\(prefix).Dynamic.Loader"
        static let card = "\(prefix).Dynamic.Card"
        static let cardTitle = "\(prefix).Dynamic.Card.Title"
        static let details = "\(prefix).Dynamic.Card.Details"
        static let toggleDetails = "\(prefix).Dynamic.ToggleDetailsButton"
        static let remove = "\(prefix).Dynamic.RemoveButton"
        static let restore = "\(prefix).Dynamic.RestoreButton"
    }

    enum Overlays {
        static let screen = "\(prefix).Overlays.Screen"
        static let alert = "\(prefix).Overlays.AlertButton"
        static let sheet = "\(prefix).Overlays.SheetButton"
        static let toast = "\(prefix).Overlays.ToastButton"
        static let alertConfirm = "\(prefix).Overlays.Alert.Confirm"
        static let result = "\(prefix).Overlays.Result"
        static let sheetContainer = "\(prefix).Overlays.Sheet"
        static let sheetTitle = "\(prefix).Overlays.Sheet.Title"
        static let sheetClose = "\(prefix).Overlays.Sheet.Close"
        static let toastMessage = "\(prefix).Overlays.Toast"
    }

    enum Catalog {
        static let screen = "\(prefix).Catalog.Screen"
        static let search = "\(prefix).Catalog.SearchField"
        static let sort = "\(prefix).Catalog.SortButton"
        static let empty = "\(prefix).Catalog.EmptyState"
        static let product = "\(prefix).Catalog.Product"
        static let productName = "\(prefix).Catalog.Product.Name"
        static let productDetails = "\(prefix).Catalog.Product.Details"
    }
}
