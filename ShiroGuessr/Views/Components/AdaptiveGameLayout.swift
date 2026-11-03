import SwiftUI

/// Arranges a gameplay screen's prompt (round, target color) and answer area (palette or map, controls).
///
/// Portrait containers stack the two vertically. Containers wider than tall — iPhone and iPad in
/// landscape, iPhone Duo's inner display — place them side by side so nothing has to scroll.
/// On a folded iPhone Duo the split follows the fold so no content straddles the hinge.
struct AdaptiveGameLayout<Prompt: View, Answer: View>: View {
    var stackSpacing: CGFloat
    @ViewBuilder var prompt: Prompt
    @ViewBuilder var answer: Answer

    private static var sideBySideGap: CGFloat { 24 }

    var body: some View {
        GeometryReader { proxy in
            let layout = layout(in: proxy)
            // AnyLayout keeps the subviews' identity when the arrangement changes on rotation or folding
            layout {
                prompt
                answer
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
    }

    private func layout(in proxy: GeometryProxy) -> AnyLayout {
        if #available(iOS 27.1, *), let split = Self.foldSplit(in: proxy) {
            return AnyLayout(split)
        }
        let size = proxy.size
        if size.width > size.height {
            let gap = Self.sideBySideGap
            return AnyLayout(SplitLayout(axis: .horizontal, firstLength: (size.width - gap) / 2, gap: gap))
        }
        return AnyLayout(VStackLayout(spacing: stackSpacing))
    }

    @available(iOS 27.1, *)
    private static func foldSplit(in proxy: GeometryProxy) -> SplitLayout? {
        let bounds = CGRect(origin: .zero, size: proxy.size)
        guard let fold = proxy.reservedRegions(kind: .division).first?.frame,
              bounds.intersects(fold) else {
            return nil
        }
        if fold.height > fold.width {
            return SplitLayout(axis: .horizontal, firstLength: max(0, fold.minX), gap: fold.width)
        }
        return SplitLayout(axis: .vertical, firstLength: max(0, fold.minY), gap: fold.height)
    }
}

/// Places two subviews in adjacent regions along `axis`, separated by `gap`, each centered in its region.
private struct SplitLayout: Layout {
    var axis: Axis
    var firstLength: CGFloat
    var gap: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let edge: CGRectEdge = axis == .horizontal ? .minXEdge : .minYEdge
        // Side-by-side columns span the full height, so keep them off the header above and the screen edge below
        let content = axis == .horizontal ? bounds.insetBy(dx: 0, dy: 8) : bounds
        let (first, rest) = content.divided(atDistance: firstLength, from: edge)
        let second = rest.divided(atDistance: gap, from: edge).remainder

        for (subview, region) in zip(subviews, [first, second]) {
            subview.place(
                at: CGPoint(x: region.midX, y: region.midY),
                anchor: .center,
                proposal: ProposedViewSize(region.size)
            )
        }
    }
}
