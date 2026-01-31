import XCTest
@testable import ShiroGuessr

final class GradientMapServiceTests: XCTestCase {
    var sut: GradientMapService!
    var colorService: ColorService!

    override func setUp() {
        super.setUp()
        colorService = ColorService()
        sut = GradientMapService(colorService: colorService)
    }

    override func tearDown() {
        sut = nil
        colorService = nil
        super.tearDown()
    }

    // MARK: - generateGradientMap Tests

    func testGenerateGradientMap_shouldCreateMapWithCorrectDimensions() {
        let map = sut.generateGradientMap(width: 50, height: 50)

        XCTAssertEqual(map.width, 50)
        XCTAssertEqual(map.height, 50)
    }

    func testGenerateGradientMap_shouldHaveFourCornerColors() {
        let map = sut.generateGradientMap()

        XCTAssertEqual(map.cornerColors.count, 4)
    }

    func testGenerateGradientMap_shouldHaveWhiteCornerColors() {
        let map = sut.generateGradientMap()

        for color in map.cornerColors {
            XCTAssertGreaterThanOrEqual(color.r, 245)
            XCTAssertLessThanOrEqual(color.r, 255)
            XCTAssertGreaterThanOrEqual(color.g, 245)
            XCTAssertLessThanOrEqual(color.g, 255)
            XCTAssertGreaterThanOrEqual(color.b, 245)
            XCTAssertLessThanOrEqual(color.b, 255)
        }
    }

    func testGenerateGradientMap_withDefaultParameters_shouldCreate50x50Map() {
        let map = sut.generateGradientMap()

        XCTAssertEqual(map.width, 50)
        XCTAssertEqual(map.height, 50)
    }

    // MARK: - getColorAt Tests

    func testGetColorAt_topLeftCorner_shouldReturnTopLeftColor() {
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

        XCTAssertEqual(color, topLeft)
    }

    func testGetColorAt_topRightCorner_shouldReturnTopRightColor() {
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

        XCTAssertEqual(color, topRight)
    }

    func testGetColorAt_bottomLeftCorner_shouldReturnBottomLeftColor() {
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

        XCTAssertEqual(color, bottomLeft)
    }

    func testGetColorAt_bottomRightCorner_shouldReturnBottomRightColor() {
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

        XCTAssertEqual(color, bottomRight)
    }

    func testGetColorAt_center_shouldReturnInterpolatedColor() {
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
        XCTAssertEqual(color.r, 250)
        XCTAssertEqual(color.g, 250)
        XCTAssertEqual(color.b, 250)
    }

    func testGetColorAt_shouldClampCoordinatesBelow0() {
        let map = sut.generateGradientMap()
        let coordinate = MapCoordinate(x: -0.5, y: -0.5)

        // Should not crash and should clamp to valid range
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        XCTAssertNotNil(color)
    }

    func testGetColorAt_shouldClampCoordinatesAbove1() {
        let map = sut.generateGradientMap()
        let coordinate = MapCoordinate(x: 1.5, y: 1.5)

        // Should not crash and should clamp to valid range
        let color = sut.getColorAt(map: map, coordinate: coordinate)

        XCTAssertNotNil(color)
    }

    // MARK: - findCoordinateForColor Tests

    func testFindCoordinateForColor_exactCornerMatch_shouldFindNearCorner() {
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
        XCTAssertLessThan(coordinate.x, 0.2)
        XCTAssertLessThan(coordinate.y, 0.2)
    }

    func testFindCoordinateForColor_shouldReturnValidCoordinate() {
        let map = sut.generateGradientMap()
        let targetColor = RGBColor(r: 250, g: 250, b: 250)

        let coordinate = sut.findCoordinateForColor(map: map, color: targetColor)

        XCTAssertGreaterThanOrEqual(coordinate.x, 0)
        XCTAssertLessThanOrEqual(coordinate.x, 1)
        XCTAssertGreaterThanOrEqual(coordinate.y, 0)
        XCTAssertLessThanOrEqual(coordinate.y, 1)
    }

    func testFindCoordinateForColor_shouldFindReasonablyCloseMatch() {
        let map = sut.generateGradientMap()
        let targetCoordinate = MapCoordinate(x: 0.5, y: 0.5)
        let targetColor = sut.getColorAt(map: map, coordinate: targetCoordinate)

        let foundCoordinate = sut.findCoordinateForColor(map: map, color: targetColor)
        let foundColor = sut.getColorAt(map: map, coordinate: foundCoordinate)

        // The found color should match the target color closely
        let distance = colorService.calculateManhattanDistance(targetColor, foundColor)
        XCTAssertLessThanOrEqual(distance, 2, "Found color should be very close to target")
    }
}
