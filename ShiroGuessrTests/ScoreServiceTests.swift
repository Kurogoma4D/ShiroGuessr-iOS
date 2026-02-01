import Testing
@testable import ShiroGuessr

@Suite("ScoreService Tests")
struct ScoreServiceTests {

    // MARK: - calculateRoundScore Tests

    @Test("calculateRoundScore perfect match should return 1000")
    func calculateRoundScore_perfectMatch_shouldReturn1000() {
        let sut = ScoreService()
        let score = sut.calculateRoundScore(distance: 0)

        #expect(score == 1000)
    }

    @Test("calculateRoundScore max distance should return 0")
    func calculateRoundScore_maxDistance_shouldReturn0() {
        let sut = ScoreService()
        let score = sut.calculateRoundScore(distance: 30)

        #expect(score == 0)
    }

    @Test("calculateRoundScore mid distance should return mid score")
    func calculateRoundScore_midDistance_shouldReturnMidScore() {
        let sut = ScoreService()
        let score = sut.calculateRoundScore(distance: 15)

        #expect(score == 500)
    }

    @Test("calculateRoundScore should decrease linearly")
    func calculateRoundScore_shouldDecreaseLinearly() {
        let sut = ScoreService()
        let score0 = sut.calculateRoundScore(distance: 0)
        let score10 = sut.calculateRoundScore(distance: 10)
        let score20 = sut.calculateRoundScore(distance: 20)
        let score30 = sut.calculateRoundScore(distance: 30)

        #expect(score0 > score10)
        #expect(score10 > score20)
        #expect(score20 > score30)
    }

    @Test("calculateRoundScore should clamp negative distance")
    func calculateRoundScore_shouldClampNegativeDistance() {
        let sut = ScoreService()
        let score = sut.calculateRoundScore(distance: -5)

        #expect(score == 1000)
    }

    @Test("calculateRoundScore should clamp distance above 30")
    func calculateRoundScore_shouldClampDistanceAbove30() {
        let sut = ScoreService()
        let score = sut.calculateRoundScore(distance: 50)

        #expect(score == 0)
    }

    @Test("calculateRoundScore specific values")
    func calculateRoundScore_specificValues() {
        let sut = ScoreService()
        // Test specific known values
        #expect(sut.calculateRoundScore(distance: 3) == 900)  // 1000 * (1 - 3/30) = 900
        #expect(sut.calculateRoundScore(distance: 6) == 800)  // 1000 * (1 - 6/30) = 800
        #expect(sut.calculateRoundScore(distance: 9) == 700)  // 1000 * (1 - 9/30) = 700
    }

    // MARK: - calculateTotalScore Tests

    @Test("calculateTotalScore empty rounds should return 0")
    func calculateTotalScore_emptyRounds_shouldReturn0() {
        let sut = ScoreService()
        let totalScore = sut.calculateTotalScore(rounds: [])

        #expect(totalScore == 0)
    }

    @Test("calculateTotalScore single completed round should return round score")
    func calculateTotalScore_singleCompletedRound_shouldReturnRoundScore() {
        let sut = ScoreService()
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

        #expect(totalScore == 1000)
    }

    @Test("calculateTotalScore multiple rounds should sum scores")
    func calculateTotalScore_multipleRounds_shouldSumScores() {
        let sut = ScoreService()
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

        #expect(totalScore == 2200)
    }

    @Test("calculateTotalScore with incomplete rounds should ignore nil scores")
    func calculateTotalScore_withIncompleteRounds_shouldIgnoreNilScores() {
        let sut = ScoreService()
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

        #expect(totalScore == 1000)
    }

    @Test("calculateTotalScore all incomplete rounds should return 0")
    func calculateTotalScore_allIncompleteRounds_shouldReturn0() {
        let sut = ScoreService()
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

        #expect(totalScore == 0)
    }
}
