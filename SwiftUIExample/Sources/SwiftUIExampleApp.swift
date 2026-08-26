import SwiftUI

/// Starts the standalone SwiftUI example application.
@main
struct SwiftUIExampleApp: App {
    init() {
        UITestStateReset.performIfRequested()
    }

    /// Presents the SwiftUI feature catalogue as the root scene.
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SwiftUIHomeView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
