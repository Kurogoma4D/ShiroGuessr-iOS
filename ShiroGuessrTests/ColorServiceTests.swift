import Testing
@testable import ShiroGuessr

@Suite("ColorService Tests")
struct ColorServiceTests {

    // MARK: - generateRandomWhiteColor Tests

    @Test("generateRandomWhiteColor should return valid white color")
    func generateRandomWhiteColor_shouldReturnValidWhiteColor() {
        let sut = ColorService()
        let color = sut.generateRandomWhiteColor()

        #expect(color.r >= 245)
        #expect(color.r <= 255)
        #expect(color.g >= 245)
        #expect(color.g <= 255)
        #expect(color.b >= 245)
        #expect(color.b <= 255)
    }

    // MARK: - generateAllWhiteColors Tests

    @Test("generateAllWhiteColors should return 1331 colors")
    func generateAllWhiteColors_shouldReturn1331Colors() {
        let sut = ColorService()
        let colors = sut.generateAllWhiteColors()

        #expect(colors.count == 1331)
    }

    @Test("generateAllWhiteColors should contain all valid combinations")
    func generateAllWhiteColors_shouldContainAllValidCombinations() {
        let sut = ColorService()
        let colors = sut.generateAllWhiteColors()

        // Verify all colors are in the white range
        for color in colors {
            #expect(color.r >= 245)
            #expect(color.r <= 255)
            #expect(color.g >= 245)
            #expect(color.g <= 255)
            #expect(color.b >= 245)
            #expect(color.b <= 255)
        }

        // Verify uniqueness
        let uniqueColors = Set(colors)
        #expect(uniqueColors.count == 1331)
    }

    @Test("generateAllWhiteColors should contain specific colors")
    func generateAllWhiteColors_shouldContainSpecificColors() {
        let sut = ColorService()
        let colors = sut.generateAllWhiteColors()

        // Test corner cases
        #expect(colors.contains(RGBColor(r: 245, g: 245, b: 245)))
        #expect(colors.contains(RGBColor(r: 255, g: 255, b: 255)))
        #expect(colors.contains(RGBColor(r: 250, g: 250, b: 250)))
    }

    // MARK: - getRandomPaletteColors Tests

    @Test("getRandomPaletteColors with default count should return 25 colors")
    func getRandomPaletteColors_withDefaultCount_shouldReturn25Colors() {
        let sut = ColorService()
        let palette = sut.getRandomPaletteColors()

        #expect(palette.count == 25)
    }

    @Test("getRandomPaletteColors with custom count should return correct amount")
    func getRandomPaletteColors_withCustomCount_shouldReturnCorrectAmount() {
        let sut = ColorService()
        let customCount = 10
        let palette = sut.getRandomPaletteColors(count: customCount)

        #expect(palette.count == customCount)
    }

    @Test("getRandomPaletteColors should return valid white colors")
    func getRandomPaletteColors_shouldReturnValidWhiteColors() {
        let sut = ColorService()
        let palette = sut.getRandomPaletteColors(count: 50)

        for paletteColor in palette {
            let color = paletteColor.color
            #expect(color.r >= 245)
            #expect(color.r <= 255)
            #expect(color.g >= 245)
            #expect(color.g <= 255)
            #expect(color.b >= 245)
            #expect(color.b <= 255)
        }
    }

    // MARK: - calculateManhattanDistance Tests

    @Test("calculateManhattanDistance with identical colors should return zero")
    func calculateManhattanDistance_identicalColors_shouldReturnZero() {
        let sut = ColorService()
        let color = RGBColor(r: 250, g: 250, b: 250)
        let distance = sut.calculateManhattanDistance(color, color)

        #expect(distance == 0)
    }

    @Test("calculateManhattanDistance max white range should return 30")
    func calculateManhattanDistance_maxWhiteRange_shouldReturn30() {
        let sut = ColorService()
        let minWhite = RGBColor(r: 245, g: 245, b: 245)
        let maxWhite = RGBColor(r: 255, g: 255, b: 255)
        let distance = sut.calculateManhattanDistance(minWhite, maxWhite)

        #expect(distance == 30)
    }

    @Test("calculateManhattanDistance should calculate correctly")
    func calculateManhattanDistance_shouldCalculateCorrectly() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 250, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 250)

        // |245-250| + |250-245| + |255-250| = 5 + 5 + 5 = 15
        let distance = sut.calculateManhattanDistance(color1, color2)

        #expect(distance == 15)
    }

    @Test("calculateManhattanDistance should be commutative")
    func calculateManhattanDistance_shouldBeCommutative() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 250, b: 255)
        let color2 = RGBColor(r: 250, g: 245, b: 250)

        let distance1 = sut.calculateManhattanDistance(color1, color2)
        let distance2 = sut.calculateManhattanDistance(color2, color1)

        #expect(distance1 == distance2)
    }

    // MARK: - interpolateColor Tests

    @Test("interpolateColor at t=0 should return first color")
    func interpolateColor_atT0_shouldReturnFirstColor() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 0.0)

        #expect(result == color1)
    }

    @Test("interpolateColor at t=1 should return second color")
    func interpolateColor_atT1_shouldReturnSecondColor() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 1.0)

        #expect(result == color2)
    }

    @Test("interpolateColor at t=0.5 should return midpoint")
    func interpolateColor_atT05_shouldReturnMidpoint() {
        let sut = ColorService()
        let color1 = RGBColor(r: 240, g: 240, b: 240)
        let color2 = RGBColor(r: 250, g: 250, b: 250)

        let result = sut.interpolateColor(color1, color2, t: 0.5)

        #expect(result.r == 245)
        #expect(result.g == 245)
        #expect(result.b == 245)
    }

    @Test("interpolateColor should clamp negative t")
    func interpolateColor_shouldClampNegativeT() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: -0.5)

        #expect(result == color1)
    }

    @Test("interpolateColor should clamp t greater than 1")
    func interpolateColor_shouldClampTGreaterThan1() {
        let sut = ColorService()
        let color1 = RGBColor(r: 245, g: 245, b: 245)
        let color2 = RGBColor(r: 255, g: 255, b: 255)

        let result = sut.interpolateColor(color1, color2, t: 1.5)

        #expect(result == color2)
    }
}
