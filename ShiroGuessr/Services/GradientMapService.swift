import Foundation

/// Service for generating and manipulating gradient maps
final class GradientMapService {
    // MARK: - Dependencies

    private let colorService: ColorService

    // MARK: - Initialization

    init(colorService: ColorService = ColorService()) {
        self.colorService = colorService
    }

    // MARK: - Public Methods

    /// Generates a gradient map with fixed white corner colors for consistent map appearance
    /// Colors are always in the range (245-255) for consistency
    /// - Parameters:
    ///   - width: Width of the map in pixels (default: 50)
    ///   - height: Height of the map in pixels (default: 50)
    /// - Returns: A GradientMap with bilinear interpolation
    func generateGradientMap(width: Int = 50, height: Int = 50) -> GradientMap {
        // Use fixed white colors (245-255) for each corner for consistent map appearance
        let topLeft = RGBColor(r: 245, g: 245, b: 245)
        let topRight = RGBColor(r: 255, g: 245, b: 255)
        let bottomLeft = RGBColor(r: 245, g: 255, b: 255)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        return GradientMap(
            width: width,
            height: height,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )
    }

    /// Gets the interpolated color at a specific coordinate using bilinear interpolation
    /// - Parameters:
    ///   - map: The gradient map
    ///   - coordinate: Normalized coordinate (0-1 range)
    /// - Returns: The interpolated RGB color at the coordinate
    func getColorAt(map: GradientMap, coordinate: MapCoordinate) -> RGBColor {
        // Clamp coordinates to [0, 1]
        let x = max(0, min(1, coordinate.x))
        let y = max(0, min(1, coordinate.y))

        // Extract corner colors
        let topLeft = map.cornerColors[0]
        let topRight = map.cornerColors[1]
        let bottomLeft = map.cornerColors[2]
        let bottomRight = map.cornerColors[3]

        // Bilinear interpolation
        // First interpolate along the top edge
        let topColor = colorService.interpolateColor(topLeft, topRight, t: x)

        // Then interpolate along the bottom edge
        let bottomColor = colorService.interpolateColor(bottomLeft, bottomRight, t: x)

        // Finally interpolate between top and bottom
        return colorService.interpolateColor(topColor, bottomColor, t: y)
    }

    /// Finds the coordinate on the map that most closely matches the target color
    /// Uses exhaustive search across all pixels
    /// - Parameters:
    ///   - map: The gradient map to search
    ///   - color: The target color to find
    /// - Returns: The coordinate with the closest matching color
    func findCoordinateForColor(map: GradientMap, color: RGBColor) -> MapCoordinate {
        var bestCoordinate = MapCoordinate(x: 0.5, y: 0.5)
        var bestDistance = Int.max

        // Search with step size for performance
        // Using 0.02 step (50 steps) gives good accuracy for 50x50 map
        let step = 0.02
        var y = 0.0

        while y <= 1.0 {
            var x = 0.0
            while x <= 1.0 {
                let coordinate = MapCoordinate(x: x, y: y)
                let mapColor = getColorAt(map: map, coordinate: coordinate)
                let distance = colorService.calculateManhattanDistance(mapColor, color)

                if distance < bestDistance {
                    bestDistance = distance
                    bestCoordinate = coordinate
                }

                x += step
            }
            y += step
        }

        return bestCoordinate
    }
}
