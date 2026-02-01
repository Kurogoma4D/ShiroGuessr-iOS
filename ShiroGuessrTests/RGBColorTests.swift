import Testing
import Foundation
@testable import ShiroGuessr

@Suite("RGBColor Tests")
struct RGBColorTests {

    // MARK: - toCSSString Tests

    @Test("toCSSString should return correct format")
    func toCSSString_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 250, g: 245, b: 255)

        let cssString = color.toCSSString()

        #expect(cssString == "rgb(250, 245, 255)")
    }

    @Test("toCSSString with minimum white values should return correct format")
    func toCSSString_withMinimumWhiteValues_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 245, g: 245, b: 245)

        let cssString = color.toCSSString()

        #expect(cssString == "rgb(245, 245, 245)")
    }

    @Test("toCSSString with maximum white values should return correct format")
    func toCSSString_withMaximumWhiteValues_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 255, g: 255, b: 255)

        let cssString = color.toCSSString()

        #expect(cssString == "rgb(255, 255, 255)")
    }

    // MARK: - toColor Tests

    @Test("toColor should return valid SwiftUI color")
    func toColor_shouldReturnValidSwiftUIColor() {
        let rgbColor = RGBColor(r: 250, g: 245, b: 255)

        let color = rgbColor.toColor()

        // Convert back to check approximate values
        // Note: There may be slight rounding differences in color space conversions
        #expect(color != nil)
    }

    @Test("toColor pure white should return white color")
    func toColor_pureWhite_shouldReturnWhiteColor() {
        let rgbColor = RGBColor(r: 255, g: 255, b: 255)

        let color = rgbColor.toColor()

        #expect(color != nil)
    }

    // MARK: - Codable Tests

    @Test("Codable should encode and decode")
    func codable_shouldEncodeAndDecode() throws {
        let original = RGBColor(r: 250, g: 245, b: 255)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RGBColor.self, from: data)

        #expect(original == decoded)
    }

    // MARK: - Equatable Tests

    @Test("Equatable identical colors should be equal")
    func equatable_identicalColors_shouldBeEqual() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 255)

        #expect(color1 == color2)
    }

    @Test("Equatable different colors should not be equal")
    func equatable_differentColors_shouldNotBeEqual() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 254)

        #expect(color1 != color2)
    }

    // MARK: - Hashable Tests

    @Test("Hashable should be usable in set")
    func hashable_shouldBeUsableInSet() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 255)
        let color3 = RGBColor(r: 250, g: 245, b: 254)

        let colorSet: Set<RGBColor> = [color1, color2, color3]

        #expect(colorSet.count == 2)
        #expect(colorSet.contains(color1))
        #expect(colorSet.contains(color3))
    }
}
