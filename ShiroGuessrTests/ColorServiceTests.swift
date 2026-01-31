import XCTest
@testable import ShiroGuessr

final class ColorServiceTests: XCTestCase {
    var sut: ColorService!

    override func setUp() {
        super.setUp()
        sut = ColorService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - generateRandomWhiteColor Tests

    func testGenerateRandomWhiteColor_shouldReturnValidWhiteColor() {
        let color = sut.generateRandomWhiteColor()

        XCTAssertGreaterThanOrEqual(color.r, 245)
        XCTAssertLessThanOrEqual(color.r, 255)
        XCTAssertGreaterThanOrEqual(color.g, 245)
        XCTAssertLessThanOrEqual(color.g, 255)
        XCTAssertGreaterThanOrEqual(color.b, 245)
        XCTAssertLessThanOrEqual(color.b, 255)
    }

    // MARK: - generateAllWhiteColors Tests

    func testGenerateAllWhiteColors_shouldReturn1331Colors() {
        let colors = sut.generateAllWhiteColors()

        XCTAssertEqual(colors.count, 1331, "Should generate 11^3 = 1,331 colors")
    }

    func testGenerateAllWhiteColors_shouldContainAllValidCombinations() {
        let colors = sut.generateAllWhiteColors()

        // Verify all colors are in the white range
        for color in colors {
            XCTAssertGreaterThanOrEqual(color.r, 245)
            XCTAssertLessThanOrEqual(color.r, 255)
            XCTAssertGreaterThanOrEqual(color.g, 245)
            XCTAssertLessThanOrEqual(color.g, 255)
            XCTAssertGreaterThanOrEqual(color.b, 245)
            XCTAssertLessThanOrEqual(color.b, 255)
        }

        // Verify uniqueness
        let uniqueColors = Set(colors)
        XCTAssertEqual(uniqueColors.count, 1331, "All colors should be unique")
    }

    func testGenerateAllWhiteColors_shouldContainSpecificColors() {
        let colors = sut.generateAllWhiteColors()

        // Test corner cases
        XCTAssertTrue(colors.contains(RGBColor(r: 245, g: 245, b: 245)), "Should contain minimum white")
        XCTAssertTrue(colors.contains(RGBColor(r: 255, g: 255, b: 255)), "Should contain pure white")
        XCTAssertTrue(colors.contains(RGBColor(r: 250, g: 250, b: 250)), "Should contain mid-range white")
    }

    // MARK: - getRandomPaletteColors Tests

    func testGetRandomPaletteColors_withDefaultCount_shouldReturn25Colors() {
        let palette = sut.getRandomPaletteColors()

        XCTAssertEqual(palette.count, 25)
    }

    func testGetRandomPaletteColors_withCustomCount_shouldReturnCorrectAmount() {
        let customCount = 10
        let palette = sut.getRandomPaletteColors(count: customCount)

        XCTAssertEqual(palette.count, customCount)
    }

    func testGetRandomPaletteColors_shouldReturnValidWhiteColors() {
        let palette = sut.getRandomPaletteColors(count: 50)

        for paletteColor in palette {
            let color = paletteColor.color
            XCTAssertGreaterThanOrEqual(color.r, 245)
            XCTAssertLessThanOrEqual(color.r, 255)
            XCTAssertGreaterThanOrEqual(color.g, 245)
            XCTAssertLessThanOrEqual(color.g, 255)
            XCTAssertGreaterThanOrEqual(color.b, 245)
            XCTAssertLessThanOrEqual(color.b, 255)
        }
    }

    // MARK: - calculateManhattanDistance Tests

    func testCalculateManhattanDistance_identicalColors_shouldReturnZero() {
        let color = RGBColor(r: 250, g: 250, b: 250)
        let distance = sut.calculateManhattanDistance(color, color)

        XCTAssertEqual(distance, 0)
    }

    func testCalculateManhattanDistance_maxWhiteRange_shouldReturn30() {
        let minWhite = RGBColor(r: 245, g: 245, b: 245)
        let maxWhite = RGBColor(r: 255, g: 255, b: 255)
        let distance = sut.calculateManhattanDistance(minWhite, maxWhite)

        XCTAssertEqual(distance, 30, "Maximum distance in white range should be 30")
    }

    func testCalculateManhattanDistance_shouldCalculateCorrectly() {
        let color1 = RGBColor(r: 245, g: 250, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 250)

        // |245-250| + |250-245| + |255-250| = 5 + 5 + 5 = 15
        let distance = sut.calculateManhattanDistance(color1, color2)

        XCTAssertEqual(distance, 15)
    }

    func testCalculateManhattanDistance_shouldBeCommutative() {
        let color1 = RGBColor(r: 245, g: 250, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 250)

        let distance1 = sut.calculateManhattanDistance(color1, color2)
        let distance2 = sut.calculateManhattanDistance(color2, color1)

        XCTAssertEqual(distance1, distance2, "Distance should be commutative")
    }

    // MARK: - interpolateColor Tests

    func testInterpolateColor_atT0_shouldReturnFirstColor() {
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 0.0)

        XCTAssertEqual(result, color1)
    }

    func testInterpolateColor_atT1_shouldReturnSecondColor() {
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 1.0)

        XCTAssertEqual(result, color2)
    }

    func testInterpolateColor_atT05_shouldReturnMidpoint() {
        let color1 = RGBColor(r: 240, g: 240, b: 240)
        let color2 = RGBColor(r: 250, g: 250, b: 250)

        let result = sut.interpolateColor(color1, color2, t: 0.5)

        XCTAssertEqual(result.r, 245)
        XCTAssertEqual(result.g, 245)
        XCTAssertEqual(result.b, 245)
    }

    func testInterpolateColor_shouldClampNegativeT() {
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: -0.5)

        XCTAssertEqual(result, color1, "Negative t should be clamped to 0")
    }

    func testInterpolateColor_shouldClampTGreaterThan1() {
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 1.5)

        XCTAssertEqual(result, color2, "t > 1 should be clamped to 1")
    }
}
