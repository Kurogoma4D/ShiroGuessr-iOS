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
        .background(Color.mdSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.mdShadow, radius: 2, x: 0, y: 1)
    }
}

/// Individual color cell in the palette
private struct ColorCell: View {
    let color: RGBColor
    let isSelected: Bool
    let isEnabled: Bool

    var body: some View {
        ZStack {
            // Color background
            color.toColor()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            isSelected ? Color.mdPrimary : Color.mdOutlineVariant,
                            lineWidth: isSelected ? 3 : 1
                        )
                )
                .opacity(isEnabled ? 1.0 : 0.5)

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
