import XCTest
@testable import ShiroGuessr

final class ShareServiceTests: XCTestCase {

    // MARK: - Test Data

    private func createTestGameState() -> GameState {
        return GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 248, g: 250, b: 250),
                    distance: 2,
                    score: 940,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 2,
                    targetColor: RGBColor(r: 255, g: 255, b: 255),
                    selectedColor: RGBColor(r: 247, g: 255, b: 255),
                    distance: 8,
                    score: 760,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 3,
                    targetColor: RGBColor(r: 245, g: 250, b: 248),
                    selectedColor: RGBColor(r: 245, g: 250, b: 248),
                    distance: 0,
                    score: 1000,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 4,
                    targetColor: RGBColor(r: 252, g: 245, b: 255),
                    selectedColor: RGBColor(r: 237, g: 245, b: 255),
                    distance: 15,
                    score: 550,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 5,
                    targetColor: RGBColor(r: 248, g: 252, b: 245),
                    selectedColor: RGBColor(r: 248, g: 247, b: 240),
                    distance: 5,
                    score: 850,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 5,
            isCompleted: true,
            totalScore: 4100,
            timeLimit: nil
        )
    }

    // MARK: - Generate Share Text Tests

    func testGenerateShareTextForCompletedGame() {
        // Given
        let gameState = createTestGameState()

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("白Guessr 🎨"))
        XCTAssertTrue(shareText.contains("スコア: 4,100 / 5,000"))
        XCTAssertTrue(shareText.contains("Round 1:"))
        XCTAssertTrue(shareText.contains("Round 5:"))
        XCTAssertTrue(shareText.contains("https://shiro-guessr.pages.dev/ios"))
        XCTAssertTrue(shareText.contains("#白Guessr"))
    }

    func testGenerateShareTextForIncompleteGame() {
        // Given
        let incompleteGameState = GameState(
            rounds: [],
            currentRoundIndex: 0,
            isCompleted: false,
            totalScore: 0,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: incompleteGameState)

        // Then
        XCTAssertTrue(shareText.isEmpty)
    }

    func testShareTextContainsAllRounds() {
        // Given
        let gameState = createTestGameState()

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        for round in gameState.rounds {
            XCTAssertTrue(shareText.contains("Round \(round.roundNumber):"))
        }
    }

    // MARK: - Star Rating Tests

    func testStarRatingForPerfectDistance() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 250, g: 248, b: 252),
                    distance: 0,
                    score: 1000,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 1000,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("⭐⭐⭐⭐⭐"))
        XCTAssertTrue(shareText.contains("(距離: 0)"))
    }

    func testStarRatingForGoodDistance() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 248, g: 250, b: 250),
                    distance: 8,
                    score: 760,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 760,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("⭐⭐⭐⭐"))
        XCTAssertTrue(shareText.contains("(距離: 8)"))
    }

    func testStarRatingForAverageDistance() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 235, g: 248, b: 252),
                    distance: 15,
                    score: 550,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 550,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("⭐⭐⭐"))
        XCTAssertTrue(shareText.contains("(距離: 15)"))
    }

    func testStarRatingForPoorDistance() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 220, g: 248, b: 252),
                    distance: 30,
                    score: 300,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 300,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("⭐⭐"))
        XCTAssertTrue(shareText.contains("(距離: 30)"))
    }

    func testStarRatingForVeryPoorDistance() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 200, g: 248, b: 252),
                    distance: 50,
                    score: 100,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 100,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("⭐"))
        XCTAssertFalse(shareText.contains("⭐⭐"))
        XCTAssertTrue(shareText.contains("(距離: 50)"))
    }

    // MARK: - Score Formatting Tests

    func testScoreFormattingWithCommas() {
        // Given
        let gameState = GameState(
            rounds: Array(repeating: GameRound(
                roundNumber: 1,
                targetColor: RGBColor(r: 250, g: 248, b: 252),
                selectedColor: RGBColor(r: 250, g: 248, b: 252),
                distance: 0,
                score: 1000,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ), count: 5),
            currentRoundIndex: 5,
            isCompleted: true,
            totalScore: 4523,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("4,523"))
    }

    func testScoreFormattingWithoutCommas() {
        // Given
        let gameState = GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 230, g: 248, b: 252),
                    distance: 20,
                    score: 500,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 1,
            isCompleted: true,
            totalScore: 500,
            timeLimit: nil
        )

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        XCTAssertTrue(shareText.contains("500"))
    }
}
