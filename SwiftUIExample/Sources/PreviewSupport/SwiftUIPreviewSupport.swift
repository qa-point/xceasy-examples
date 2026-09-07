import SwiftUI

#if DEBUG
/// Keeps screen previews in the same navigation context as the application.
struct SwiftUIScreenPreview<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationView {
            content
        }
        .navigationViewStyle(.stack)
    }
}
#endif
