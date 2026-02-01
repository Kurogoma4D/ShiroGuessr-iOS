import Testing
@testable import ShiroGuessr

@Suite("GradientMapService Tests")
struct GradientMapServiceTests {

    // MARK: - generateGradientMap Tests

    @Test("generateGradientMap should create map with correct dimensions")
    func generateGradientMap_shouldCreateMapWithCorrectDimensions() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap(width: 50, height: 50)

        #expect(map.width == 50)
        #expect(map.height == 50)
    }

    @Test("generateGradientMap should have four corner colors")
    func generateGradientMap_shouldHaveFourCornerColors() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()

        #expect(map.cornerColors.count == 4)
    }

    @Test("generateGradientMap should have white corner colors")
    func generateGradientMap_shouldHaveWhiteCornerColors() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()

        for color in map.cornerColors {
            #expect(color.r >= 245)
            #expect(color.r <= 255)
            #expect(color.g >= 245)
            #expect(color.g <= 255)
            #expect(color.b >= 245)
            #expect(color.b <= 255)
        }
    }

    @Test("generateGradientMap with default parameters should create 50x50 map")
    func generateGradientMap_withDefaultParameters_shouldCreate50x50Map() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()

        #expect(map.width == 50)
        #expect(map.height == 50)
    }

    // MARK: - getColorAt Tests

    @Test("getColorAt top-left corner should return top-left color")
    func getColorAt_topLeftCorner_shouldReturnTopLeftColor() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 245, g: 250, b: 255)
        let topRight = RGBColor(r: 255, g: 245, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 255, b: 245)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = MapCoordinate(x: 0, y: 0)
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color == topLeft)
    }

    @Test("getColorAt top-right corner should return top-right color")
    func getColorAt_topRightCorner_shouldReturnTopRightColor() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 245, g: 250, b: 255)
        let topRight = RGBColor(r: 255, g: 245, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 255, b: 245)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = MapCoordinate(x: 1, y: 0)
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color == topRight)
    }

    @Test("getColorAt bottom-left corner should return bottom-left color")
    func getColorAt_bottomLeftCorner_shouldReturnBottomLeftColor() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 245, g: 250, b: 255)
        let topRight = RGBColor(r: 255, g: 245, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 255, b: 245)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = MapCoordinate(x: 0, y: 1)
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color == bottomLeft)
    }

    @Test("getColorAt bottom-right corner should return bottom-right color")
    func getColorAt_bottomRightCorner_shouldReturnBottomRightColor() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 245, g: 250, b: 255)
        let topRight = RGBColor(r: 255, g: 245, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 255, b: 245)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = MapCoordinate(x: 1, y: 1)
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color == bottomRight)
    }

    @Test("getColorAt center should return interpolated color")
    func getColorAt_center_shouldReturnInterpolatedColor() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 250, g: 250, b: 250)
        let topRight = RGBColor(r: 250, g: 250, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 250, b: 250)
        let bottomRight = RGBColor(r: 250, g: 250, b: 250)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = MapCoordinate(x: 0.5, y: 0.5)
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        // With all corners the same, center should be the same
        #expect(color.r == 250)
        #expect(color.g == 250)
        #expect(color.b == 250)
    }

    @Test("getColorAt should clamp coordinates below 0")
    func getColorAt_shouldClampCoordinatesBelow0() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()
        let coordinate = MapCoordinate(x: -0.5, y: -0.5)

        // Should not crash and should clamp to valid range
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color != nil)
    }

    @Test("getColorAt should clamp coordinates above 1")
    func getColorAt_shouldClampCoordinatesAbove1() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()
        let coordinate = MapCoordinate(x: 1.5, y: 1.5)

        // Should not crash and should clamp to valid range
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        #expect(color != nil)
    }

    // MARK: - findCoordinateForColor Tests

    @Test("findCoordinateForColor exact corner match should find near corner")
    func findCoordinateForColor_exactCornerMatch_shouldFindNearCorner() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let topLeft = RGBColor(r: 245, g: 250, b: 255)
        let topRight = RGBColor(r: 255, g: 245, b: 250)
        let bottomLeft = RGBColor(r: 250, g: 255, b: 245)
        let bottomRight = RGBColor(r: 255, g: 255, b: 245)

        let map = GradientMap(
            width: 50,
            height: 50,
            cornerColors: [topLeft, topRight, bottomLeft, bottomRight]
        )

        let coordinate = sut.findCoordinateForColor(map: map, color: topLeft)

        // Should find a coordinate close to top-left (0, 0)
        #expect(coordinate.x < 0.2)
        #expect(coordinate.y < 0.2)
    }

    @Test("findCoordinateForColor should return valid coordinate")
    func findCoordinateForColor_shouldReturnValidCoordinate() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()
        let targetColor = RGBColor(r: 250, g: 250, b: 250)

        let coordinate = sut.findCoordinateForColor(map: map, color: targetColor)

        #expect(coordinate.x >= 0)
        #expect(coordinate.x <= 1)
        #expect(coordinate.y >= 0)
        #expect(coordinate.y <= 1)
    }

    @Test("findCoordinateForColor should find reasonably close match")
    func findCoordinateForColor_shouldFindReasonablyCloseMatch() {
        let colorService = ColorService()
        let sut = GradientMapService(colorService: colorService)
        let map = sut.generateGradientMap()
        let targetCoordinate = MapCoordinate(x: 0.5, y: 0.5)
        let targetColor = sut.getColorAt(map: map, coordinate: targetCoordinate)

        let foundCoordinate = sut.findCoordinateForColor(map: map, color: targetColor)
        let foundColor = sut.getColorAt(map: map, coordinate: foundCoordinate)

        // The found color should match the target color closely
        let distance = colorService.calculateManhattanDistance(targetColor, foundColor)
        #expect(distance <= 2)
    }
}
