import SwiftUI

/// Demonstrates system and custom overlay lifecycles.
struct SwiftUIOverlaysView: View {
    @State private var isAlertPresented = false
    @State private var isSheetPresented = false
    @State private var isToastPresented = false
    @State private var result = "No action selected"

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Overlays")
                    .font(.largeTitle.bold())

                Button("Show confirmation alert") { isAlertPresented = true }
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.alert)
                Button("Open bottom sheet") { isSheetPresented = true }
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.sheet)
                Button("Show toast", action: showToast)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.toast)

                Text(result)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.result)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if isToastPresented {
                Text("Settings saved")
                    .padding()
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.toastMessage)
            }
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.screen)
        .navigationTitle("Overlays")
        .alert("Confirm action", isPresented: $isAlertPresented) {
            Button("Cancel", role: .cancel) { result = "Action cancelled" }
            Button("Confirm") { result = "Action confirmed" }
        } message: {
            Text("This is a deterministic mocked confirmation.")
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack(spacing: 20) {
                Text("Feature details")
                    .font(.title.bold())
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.sheetTitle)
                Text("Sheets are useful for testing a separate accessibility hierarchy.")
                Button("Close") { isSheetPresented = false }
                    .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.sheetClose)
            }
            .padding()
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier(SwiftUIIdentifiers.Overlays.sheetContainer)
        }
    }

    /// Shows a toast and removes it from the tree after four seconds.
    private func showToast() {
        withAnimation { isToastPresented = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation { isToastPresented = false }
        }
    }
}
