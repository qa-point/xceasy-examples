# Feature catalog

Both applications implement the same user flows using different UI technologies. This compares XCUITest and XCEasy behavior without mixing UIKit and SwiftUI in one target.

## Manual verification

### Authorization

Open `Authorization` and verify four branches:

1. Empty login with a password → `Enter your login.`
2. Login with an empty password → `Enter your password.`
3. Any invalid pair → `Incorrect login or password.`
4. `admin` / `password` → the button becomes disabled, the loader stays for three seconds, then `Authorization successful` appears.

### Components

The field accepts text, the checkbox changes selected state, and selecting an option deselects the previous one. Dismissing the banner removes it from the accessibility tree. Restore creates a new banner with the same identifiers and a new sequence number. Four rows exercise `XCEasyComponentCollection`, count, first, and last.

### Dynamic content

The card is absent before Load. A loader appears after the tap; 1.5 seconds later the card animates onto the screen. Details can be toggled, Remove deletes the entire card, and Restore creates it again.

### Overlays

This screen presents a system confirmation alert, a modal sheet with its own Close button, and a toast that leaves the tree after four seconds.

### Product catalog

The catalog contains four products with names, prices, and availability. Every card and child field uses the same identifiers; tests select a card by index and then find `name` and `details` only inside that card. Sort checks the actual visual order instead of merely proving that a product exists somewhere on screen. Search filters the list and exposes an empty state.

## UI-test coverage

Each target runs the same 14 iterations split across six feature-focused test classes: Home,
Authorization, Components, Dynamic Content, Overlays, and Catalog. Every scenario uses GWT business
steps, with technical XCEasy actions and assertions nested beneath them. Coverage includes home
readiness; three parameterized negative authorization cases; successful login and loader lifecycle;
two parameterized input cases; selected-state and collection assertions; lazy POM re-resolution
after banner replacement; dynamic loader, animation, details, removal and restoration; alert, sheet
and toast lifecycles; catalog count, data, sorting and filtering.

Together the apps provide 28 test iterations. Both targets use the safe default `.hittable` action readiness, so XCEasy acts only after XCTest confirms that the element can receive the interaction.

## Identifier contract

UIKit identifiers start with `UIKitExample.` and SwiftUI identifiers with `SwiftUIExample.`. Names describe screen and role, such as `SwiftUIExample.Authorization.LoginField`. They never depend on localized labels.
