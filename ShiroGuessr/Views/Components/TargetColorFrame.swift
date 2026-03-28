import SwiftUI

/// Gallery-style target color display frame.
///
/// Renders the target color as a full-width banner framed by thin border lines
/// above and below, evoking a gallery exhibit. A small, muted "TARGET" label
/// sits above the color so the color itself commands attention.
///
/// - Parameters:
///   - color: The target `RGBColor` to display.
///   - height: Banner height (default 80 for Classic, use smaller for Map).
///   - showCSSValue: Whether to show the CSS rgb() string below the banner.
struct TargetColorFrame: View {
    let color: RGBColor
    var height: CGFloat = 80
    var showCSSValue: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // "TARGET" label — intentionally English (gallery exhibit style, not localized)
            Text("TARGET")
                .font(.mdLabelSmall)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .kerning(2)
                .padding(.bottom, 8)

            // Top border line
            Rectangle()
                .fill(Color.sampleBorder)
                .frame(height: 1.5)

            // Color banner — full width
            Rectangle()
                .fill(color.toColor())
                .frame(height: height)
                .overlay(
                    // Subtle inner border so near-white colors
                    // do not disappear against the frame
                    Rectangle()
                        .strokeBorder(Color.sampleBorder, lineWidth: 1)
                )

            // Bottom border line
            Rectangle()
                .fill(Color.sampleBorder)
                .frame(height: 1.5)

            // CSS value — shown only on result screen
            if showCSSValue {
                Text(color.toCSSString())
                    .font(.mdMono)
                    .foregroundStyle(Color.textMuted)
                    .padding(.top, 8)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Accessibility.targetColor(color.toCSSString()))
    }
}

// MARK: - Previews

#Preview("Classic — Gameplay") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TargetColorFrame(
            color: RGBColor(r: 250, g: 248, b: 252),
            height: 80,
            showCSSValue: false
        )
        .padding(.horizontal, 16)
    }
}

#Preview("Classic — Result") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TargetColorFrame(
            color: RGBColor(r: 250, g: 248, b: 252),
            height: 80,
            showCSSValue: true
        )
        .padding(.horizontal, 16)
    }
}

#Preview("Map — Compact") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TargetColorFrame(
            color: RGBColor(r: 248, g: 252, b: 245),
            height: 50,
            showCSSValue: false
        )
        .padding(.horizontal, 16)
    }
}
