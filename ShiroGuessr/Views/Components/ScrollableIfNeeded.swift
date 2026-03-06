import SwiftUI

/// A container that enables vertical scrolling only when the content
/// exceeds the available height on iPad in landscape orientation.
/// On iPhone or iPad in portrait, scrolling is disabled to prevent overscroll.
struct ScrollableIfNeeded<Content: View>: View {
    @ViewBuilder var content: Content

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @State private var contentHeight: CGFloat = 0
    @State private var containerHeight: CGFloat = 0

    private var isIPadLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    private var needsScroll: Bool {
        isIPadLandscape && contentHeight > containerHeight
    }

    var body: some View {
        GeometryReader { geometry in
            if needsScroll {
                ScrollView(.vertical, showsIndicators: true) {
                    content
                        .measureHeight { contentHeight = $0 }
                }
            } else {
                content
                    .measureHeight { contentHeight = $0 }
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { newValue in
            containerHeight = newValue
        }
    }
}

// MARK: - Height measurement

private struct HeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private extension View {
    func measureHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                }
            )
            .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
    }
}
