import SwiftUI

/// Card/panel style modifier following Shiro Gallery design
/// - Background: canvasElevated (#1A1A22) = Color.mdSurface
/// - Corner radius: 16dp
/// - Border: 1dp #2A2A35 = Color.mdOutlineVariant
/// - Shadow: 0 4dp 16dp rgba(0,0,0,0.4)
struct CardPanelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.mdSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.mdOutlineVariant, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

extension View {
    /// Applies the Shiro Gallery card/panel style
    func cardPanelStyle() -> some View {
        modifier(CardPanelModifier())
    }
}
