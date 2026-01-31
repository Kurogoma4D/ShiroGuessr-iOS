import Foundation
import SwiftUI

/// RGB color representation with values from 0-255
struct RGBColor: Codable, Equatable, Hashable {
    /// Red component (0-255)
    let r: Int
    /// Green component (0-255)
    let g: Int
    /// Blue component (0-255)
    let b: Int

    /// Converts the RGB color to SwiftUI Color
    /// - Returns: SwiftUI Color representation
    func toColor() -> Color {
        Color(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0
        )
    }

    /// Converts the RGB color to CSS color string
    /// - Returns: CSS color string in format "rgb(r, g, b)"
    func toCSSString() -> String {
        "rgb(\(r), \(g), \(b))"
    }
}
