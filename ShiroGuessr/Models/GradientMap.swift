import Foundation

/// Gradient map with bilinear interpolation
struct GradientMap: Codable, Equatable {
    /// Width of the map in pixels
    let width: Int
    /// Height of the map in pixels
    let height: Int
    /// Colors at the four corners: [topLeft, topRight, bottomLeft, bottomRight]
    let cornerColors: [RGBColor]

    init(width: Int, height: Int, cornerColors: [RGBColor]) {
        precondition(cornerColors.count == 4, "GradientMap requires exactly 4 corner colors")
        self.width = width
        self.height = height
        self.cornerColors = cornerColors
    }
}
