import Foundation

/// Service for generating and manipulating colors
final class ColorService {
    /// Minimum RGB value for white colors (inclusive)
    private let minWhiteValue = 245

    /// Maximum RGB value for white colors (inclusive)
    private let maxWhiteValue = 255

    /// Generates a random white color with RGB values between 245-255
    /// - Returns: A random white RGBColor
    func generateRandomWhiteColor() -> RGBColor {
        RGBColor(
            r: randomInRange(min: minWhiteValue, max: maxWhiteValue),
            g: randomInRange(min: minWhiteValue, max: maxWhiteValue),
            b: randomInRange(min: minWhiteValue, max: maxWhiteValue)
        )
    }

    /// Generates all possible white colors (RGB 245-255)
    /// Total: 11 × 11 × 11 = 1,331 colors
    /// - Returns: Array of all possible white colors
    func generateAllWhiteColors() -> [RGBColor] {
        var colors: [RGBColor] = []
        for r in minWhiteValue...maxWhiteValue {
            for g in minWhiteValue...maxWhiteValue {
                for b in minWhiteValue...maxWhiteValue {
                    colors.append(RGBColor(r: r, g: g, b: b))
                }
            }
        }
        return colors
    }

    /// Gets a random sample of palette colors from all possible white colors
    /// - Parameter count: Number of colors to sample (default: 25)
    /// - Returns: Array of random palette colors
    func getRandomPaletteColors(count: Int = 25) -> [PaletteColor] {
        let allColors = generateAllWhiteColors()
        let shuffled = allColors.shuffled()
        return shuffled.prefix(count).map { PaletteColor(color: $0) }
    }

    /// Calculates the Manhattan distance between two RGB colors
    /// Formula: |r1 - r2| + |g1 - g2| + |b1 - b2|
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    /// - Returns: Manhattan distance (0-30 for white colors)
    func calculateManhattanDistance(_ color1: RGBColor, _ color2: RGBColor) -> Int {
        abs(color1.r - color2.r) + abs(color1.g - color2.g) + abs(color1.b - color2.b)
    }

    /// Interpolates between two colors using linear interpolation
    /// - Parameters:
    ///   - color1: First color
    ///   - color2: Second color
    ///   - t: Interpolation factor (0-1). 0 returns color1, 1 returns color2
    /// - Returns: Interpolated color
    func interpolateColor(_ color1: RGBColor, _ color2: RGBColor, t: Double) -> RGBColor {
        // Clamp t to [0, 1]
        let clampedT = max(0, min(1, t))

        return RGBColor(
            r: Int(round(Double(color1.r) + Double(color2.r - color1.r) * clampedT)),
            g: Int(round(Double(color1.g) + Double(color2.g - color1.g) * clampedT)),
            b: Int(round(Double(color1.b) + Double(color2.b - color1.b) * clampedT))
        )
    }

    // MARK: - Private Methods

    /// Generates a random integer between min and max (inclusive)
    /// - Parameters:
    ///   - min: Minimum value (inclusive)
    ///   - max: Maximum value (inclusive)
    /// - Returns: Random integer
    private func randomInRange(min: Int, max: Int) -> Int {
        Int.random(in: min...max)
    }
}
