import Foundation

/// Pin placed on the gradient map
struct Pin: Codable, Equatable {
    /// The coordinate where the pin is placed
    let coordinate: MapCoordinate
    /// The color at the pin location
    let color: RGBColor
}
