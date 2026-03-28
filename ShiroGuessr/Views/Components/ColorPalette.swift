import SwiftUI

/// Component displaying a 5x5 grid of selectable colors
struct ColorPalette: View {
    let colors: [PaletteColor]
    let selectedColor: RGBColor?
    let onColorSelected: (RGBColor) -> Void
    let isEnabled: Bool

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(colors.indices, id: \.self) { index in
                let color = colors[index].color
                ColorCell(
                    color: color,
                    isSelected: selectedColor == color,
                    isEnabled: isEnabled
                )
                .onTapGesture {
                    if isEnabled {
                        onColorSelected(color)
                    }
                }
            }
        }
        .padding(16)
        .cardPanelStyle()
    }
}

/// Individual color cell in the palette
/// - Corner radius: 16dp
/// - Border default: 1.5dp sampleBorder (#3A3A45)
/// - Border selected: 2.5dp accentPrimary with glow
/// - Shadow: 0 2dp 6dp rgba(0,0,0,0.3)
/// - Selected scale: 1.05
private struct ColorCell: View {
    let color: RGBColor
    let isSelected: Bool
    let isEnabled: Bool

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
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                .opacity(isEnabled ? 1.0 : 0.5)

            // Glow effect for selected cell
            if isSelected {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mdPrimary.opacity(0.4), lineWidth: 4)
                    .blur(radius: 4)
            }

            // Selection indicator
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.mdPrimary)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 18, height: 18)
                    )
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedColor: RGBColor? = RGBColor(r: 250, g: 250, b: 250)

        var body: some View {
            VStack(spacing: 24) {
                Text("Color Palette - Enabled")
                    .font(.mdTitleMedium)

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
