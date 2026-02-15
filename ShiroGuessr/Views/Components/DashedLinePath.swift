import SwiftUI

/// A Shape that draws a straight line between two points in normalized coordinates (0-1).
/// Compatible with `.trim(from:to:)` for animated drawing.
struct DashedLinePath: Shape {
    /// Start point in normalized coordinates (0-1)
    let from: CGPoint
    /// End point in normalized coordinates (0-1)
    let to: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(
            x: from.x * rect.width,
            y: from.y * rect.height
        )
        let end = CGPoint(
            x: to.x * rect.width,
            y: to.y * rect.height
        )
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}
