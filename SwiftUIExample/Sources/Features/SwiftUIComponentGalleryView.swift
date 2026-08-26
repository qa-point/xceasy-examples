import SwiftUI

/// Catalogue of reusable controls and accessibility states.
struct SwiftUIComponentGalleryView: View {
    @State private var input = ""
    @State private var notificationsEnabled = false
    @State private var termsAccepted = false
    @State private var selectedOption = "first"
    @State private var bannerGeneration = 1
    @State private var isBannerPresented = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Component Gallery")
                    .font(.largeTitle.bold())

                if isBannerPresented {
                    banner
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                Button("Restore promo banner") {
                    bannerGeneration += 1
                    withAnimation { isBannerPresented = true }
                }
                .accessibilityIdentifier(SwiftUIIdentifiers.Components.bannerRestore)

                GroupBox("Text input") {
                    TextField("Enter a value", text: $input)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier(SwiftUIIdentifiers.Components.input)
                }

                Toggle("Enable notifications", isOn: $notificationsEnabled)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Components.toggle)

                selectionButton(
                    title: "Accept terms",
                    isSelected: termsAccepted,
                    identifier: SwiftUIIdentifiers.Components.checkbox
                ) {
                    termsAccepted.toggle()
                }

                GroupBox("Delivery option") {
                    VStack {
                        selectionButton(
                            title: "Standard",
                            isSelected: selectedOption == "first",
                            identifier: SwiftUIIdentifiers.Components.firstOption
                        ) { selectedOption = "first" }
                        selectionButton(
                            title: "Express",
                            isSelected: selectedOption == "second",
                            identifier: SwiftUIIdentifiers.Components.secondOption
                        ) { selectedOption = "second" }
                    }
                }

                GroupBox("Reusable collection") {
                    VStack(spacing: 8) {
                        ForEach(1...4, id: \.self) { index in
                            HStack {
                                Image(systemName: "shippingbox")
                                Text("Gallery item \(index)")
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .accessibilityElement(children: .combine)
                            .accessibilityIdentifier(SwiftUIIdentifiers.Components.listItem)
                        }
                    }
                }
            }
            .padding()
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Components.screen)
        .navigationTitle("Components")
    }

    /// Banner whose removal and recreation exercise lazy locator resolution.
    private var banner: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Special offer \(bannerGeneration)")
                    .font(.headline)
                    .accessibilityIdentifier(SwiftUIIdentifiers.Components.bannerTitle)
                Text("The same identifiers are reused after recreation.")
                    .font(.caption)
            }
            Spacer()
            Button {
                withAnimation { isBannerPresented = false }
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .accessibilityLabel("Close promo banner")
            .accessibilityIdentifier(SwiftUIIdentifiers.Components.bannerClose)
        }
        .padding()
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(SwiftUIIdentifiers.Components.banner)
    }

    /// Builds a button that exposes an explicit selected accessibility state.
    private func selectionButton(
        title: String,
        isSelected: Bool,
        identifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                Text(title)
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 6)
        .accessibilityIdentifier(identifier)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
