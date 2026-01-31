import XCTest
@testable import ShiroGuessr

final class ScoreServiceTests: XCTestCase {
    var sut: ScoreService!

    override func setUp() {
        super.setUp()
        sut = ScoreService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - calculateRoundScore Tests

    func testCalculateRoundScore_perfectMatch_shouldReturn1000() {
        let score = sut.calculateRoundScore(distance: 0)

        XCTAssertEqual(score, 1000, "Perfect match (distance 0) should score 1000")
    }

    func testCalculateRoundScore_maxDistance_shouldReturn0() {
        let score = sut.calculateRoundScore(distance: 30)

        XCTAssertEqual(score, 0, "Maximum distance (30) should score 0")
    }

    func testCalculateRoundScore_midDistance_shouldReturnMidScore() {
        let score = sut.calculateRoundScore(distance: 15)

        XCTAssertEqual(score, 500, "Mid distance (15) should score approximately 500")
    }

    func testCalculateRoundScore_shouldDecreaseLinearly() {
        let score0 = sut.calculateRoundScore(distance: 0)
        let score10 = sut.calculateRoundScore(distance: 10)
        let score20 = sut.calculateRoundScore(distance: 20)
        let score30 = sut.calculateRoundScore(distance: 30)

        XCTAssertGreaterThan(score0, score10)
        XCTAssertGreaterThan(score10, score20)
        XCTAssertGreaterThan(score20, score30)
    }

    func testCalculateRoundScore_shouldClampNegativeDistance() {
        let score = sut.calculateRoundScore(distance: -5)

        XCTAssertEqual(score, 1000, "Negative distance should be clamped to 0, scoring 1000")
    }

    func testCalculateRoundScore_shouldClampDistanceAbove30() {
        let score = sut.calculateRoundScore(distance: 50)

        XCTAssertEqual(score, 0, "Distance above 30 should be clamped to 30, scoring 0")
    }

    func testCalculateRoundScore_specificValues() {
        // Test specific known values
        XCTAssertEqual(sut.calculateRoundScore(distance: 3), 900)  // 1000 * (1 - 3/30) = 900
        XCTAssertEqual(sut.calculateRoundScore(distance: 6), 800)  // 1000 * (1 - 6/30) = 800
        XCTAssertEqual(sut.calculateRoundScore(distance: 9), 700)  // 1000 * (1 - 9/30) = 700
    }

    // MARK: - calculateTotalScore Tests

    func testCalculateTotalScore_emptyRounds_shouldReturn0() {
        let totalScore = sut.calculateTotalScore(rounds: [])

        XCTAssertEqual(totalScore, 0)
    }

    func testCalculateTotalScore_singleCompletedRound_shouldReturnRoundScore() {
        let round = GameRound(
            roundNumber: 1,
            targetColor: RGBColor(r: 250, g: 250, b: 250),
            selectedColor: RGBColor(r: 250, g: 250, b: 250),
            distance: 0,
            score: 1000,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let totalScore = sut.calculateTotalScore(rounds: [round])

        XCTAssertEqual(totalScore, 1000)
    }

    func testCalculateTotalScore_multipleRounds_shouldSumScores() {
        let round1 = GameRound(
            roundNumber: 1,
            targetColor: RGBColor(r: 250, g: 250, b: 250),
            selectedColor: RGBColor(r: 250, g: 250, b: 250),
            distance: 0,
            score: 1000,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let round2 = GameRound(
            roundNumber: 2,
            targetColor: RGBColor(r: 245, g: 245, b: 245),
            selectedColor: RGBColor(r: 250, g: 250, b: 250),
            distance: 15,
            score: 500,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let round3 = GameRound(
            roundNumber: 3,
            targetColor: RGBColor(r: 255, g: 255, b: 255),
            selectedColor: RGBColor(r: 252, g: 252, b: 252),
            distance: 9,
            score: 700,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let totalScore = sut.calculateTotalScore(rounds: [round1, round2, round3])

        XCTAssertEqual(totalScore, 2200, "Total should be 1000 + 500 + 700")
    }

    func testCalculateTotalScore_withIncompleteRounds_shouldIgnoreNilScores() {
        let completedRound = GameRound(
            roundNumber: 1,
            targetColor: RGBColor(r: 250, g: 250, b: 250),
            selectedColor: RGBColor(r: 250, g: 250, b: 250),
            distance: 0,
            score: 1000,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let incompleteRound = GameRound(
            roundNumber: 2,
            targetColor: RGBColor(r: 245, g: 245, b: 245),
            selectedColor: nil,
            distance: nil,
            score: nil,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let totalScore = sut.calculateTotalScore(rounds: [completedRound, incompleteRound])

        XCTAssertEqual(totalScore, 1000, "Should only count completed round")
    }

    func testCalculateTotalScore_allIncompleteRounds_shouldReturn0() {
        let round1 = GameRound(
            roundNumber: 1,
            targetColor: RGBColor(r: 250, g: 250, b: 250),
            selectedColor: nil,
            distance: nil,
            score: nil,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let round2 = GameRound(
            roundNumber: 2,
            targetColor: RGBColor(r: 245, g: 245, b: 245),
            selectedColor: nil,
            distance: nil,
            score: nil,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        let totalScore = sut.calculateTotalScore(rounds: [round1, round2])

        XCTAssertEqual(totalScore, 0, "No completed rounds should score 0")
    }
}
