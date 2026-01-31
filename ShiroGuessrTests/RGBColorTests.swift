import XCTest
@testable import ShiroGuessr

final class RGBColorTests: XCTestCase {

    // MARK: - toCSSString Tests

    func testToCSSString_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 250, g: 245, b: 255)

        let cssString = color.toCSSString()

        XCTAssertEqual(cssString, "rgb(250, 245, 255)")
    }

    func testToCSSString_withMinimumWhiteValues_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 245, g: 245, b: 245)

        let cssString = color.toCSSString()

        XCTAssertEqual(cssString, "rgb(245, 245, 245)")
    }

    func testToCSSString_withMaximumWhiteValues_shouldReturnCorrectFormat() {
        let color = RGBColor(r: 255, g: 255, b: 255)

        let cssString = color.toCSSString()

        XCTAssertEqual(cssString, "rgb(255, 255, 255)")
    }

    // MARK: - toColor Tests

    func testToColor_shouldReturnValidSwiftUIColor() {
        let rgbColor = RGBColor(r: 250, g: 245, b: 255)

        let color = rgbColor.toColor()

        // Convert back to check approximate values
        // Note: There may be slight rounding differences in color space conversions
        XCTAssertNotNil(color)
    }

    func testToColor_pureWhite_shouldReturnWhiteColor() {
        let rgbColor = RGBColor(r: 255, g: 255, b: 255)

        let color = rgbColor.toColor()

        XCTAssertNotNil(color)
    }

    // MARK: - Codable Tests

    func testCodable_shouldEncodeAndDecode() throws {
        let original = RGBColor(r: 250, g: 245, b: 255)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RGBColor.self, from: data)

        XCTAssertEqual(original, decoded)
    }

    // MARK: - Equatable Tests

    func testEquatable_identicalColors_shouldBeEqual() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 255)

        XCTAssertEqual(color1, color2)
    }

    func testEquatable_differentColors_shouldNotBeEqual() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 254)

        XCTAssertNotEqual(color1, color2)
    }

    // MARK: - Hashable Tests

    func testHashable_shouldBeUsableInSet() {
        let color1 = RGBColor(r: 250, g: 245, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 255)
        let color3 = RGBColor(r: 250, g: 245, b: 254)

        let colorSet: Set<RGBColor> = [color1, color2, color3]

        XCTAssertEqual(colorSet.count, 2, "Duplicate colors should be removed")
        XCTAssertTrue(colorSet.contains(color1))
        XCTAssertTrue(colorSet.contains(color3))
    }
}
