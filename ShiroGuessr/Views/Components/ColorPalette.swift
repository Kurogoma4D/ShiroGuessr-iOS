import SwiftUI

/// Component displaying a 5x5 grid of selectable colors
/// Redesigned with gallery-style presentation: gold ring selection,
/// tap sink effect, and elevated dark surface card.
struct ColorPalette: View {
    let colors: [PaletteColor]
    let selectedColor: RGBColor?
    let onColorSelected: (RGBColor) -> Void
    let isEnabled: Bool

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(colors.indices, id: \.self) { index in
                let color = colors[index].color
                ColorCell(
                    color: color,
                    index: index + 1,
                    totalCount: colors.count,
                    isSelected: selectedColor == color,
                    isEnabled: isEnabled,
                    onTap: {
                        if isEnabled {
                            onColorSelected(color)
                        }
                    }
                )
            }
        }
        .padding(16)
        .cardPanelStyle()
        .accessibilityLabel(L10n.Accessibility.colorPalette)
    }
}

/// Individual color cell in the palette with gallery-style interactions
private struct ColorCell: View {
    let color: RGBColor
    let index: Int
    let totalCount: Int
    let isSelected: Bool
    let isEnabled: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    /// Scale factor: pressed -> 0.95, selected -> 1.05, default -> 1.0
    private var scaleValue: CGFloat {
        if isPressed {
            return 0.95
        } else if isSelected {
            return 1.05
        } else {
            return 1.0
        }
    }

    var body: some View {
        ZStack {
            // Color background
            color.toColor()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isSelected ? Color.mdPrimary : Color.sampleBorder,
                            lineWidth: isSelected ? 2.5 : 1.5
                        )
                )
                .shadow(
                    color: isSelected ? Color.mdPrimary.opacity(0.4) : Color.clear,
                    radius: isSelected ? 6 : 0,
                    x: 0,
                    y: 0
                )
                .opacity(isEnabled ? 1.0 : 0.5)

            // Gold ring selection indicator
            if isSelected {
                GoldRingIndicator()
            }
        }
        .scaleEffect(scaleValue)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard isEnabled, !isPressed else { return }
                    withAnimation(AnimationConstants.quickResponse) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    guard isEnabled else { return }
                    withAnimation(AnimationConstants.quickResponse) {
                        isPressed = false
                    }
                    onTap()
                }
        )
        .animation(AnimationConstants.spring, value: isSelected)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Accessibility.colorCell(index, totalCount, color.toCSSString()))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(isEnabled ? L10n.Accessibility.tapToSelect : "")
        .accessibilityAction {
            if isEnabled { onTap() }
        }
    }
}

/// Animated gold ring indicator replacing the checkmark icon
private struct GoldRingIndicator: View {
    @State private var ringScale: CGFloat = 0.5
    @State private var ringOpacity: Double = 0.0

    var body: some View {
        Circle()
            .strokeBorder(Color.mdPrimary, lineWidth: 2.5)
            .frame(width: 20, height: 20)
            .background(
                Circle()
                    .fill(Color.mdPrimary.opacity(0.15))
                    .frame(width: 20, height: 20)
            )
            .scaleEffect(ringScale)
            .opacity(ringOpacity)
            .onAppear {
                withAnimation(AnimationConstants.spring) {
                    ringScale = 1.0
                    ringOpacity = 1.0
                }
            }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedColor: RGBColor? = RGBColor(r: 250, g: 250, b: 250)

        var body: some View {
            VStack(spacing: 24) {
                Text("Color Palette - Enabled")
                    .font(.mdTitleMedium)
                    .foregroundStyle(Color.mdOnSurface)

                ColorPalette(
                    colors: ColorService().getRandomPaletteColors(count: 25),
                    selectedColor: selectedColor,
                    onColorSelected: { color in
                        selectedColor = color
                    },
                    isEnabled: true
                )
                .padding()

                Text("Color Palette - Disabled")
                    .font(.mdTitleMedium)
                    .foregroundStyle(Color.mdOnSurface)

                ColorPalette(
                    colors: ColorService().getRandomPaletteColors(count: 25),
                    selectedColor: selectedColor,
                    onColorSelected: { _ in },
                    isEnabled: false
                )
                .padding()
            }
            .background(Color.mdBackground)
        }
    }

    return PreviewWrapper()
}
