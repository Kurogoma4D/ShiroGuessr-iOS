import Testing
@testable import ShiroGuessr

@Suite("ShareService Tests")
struct ShareServiceTests {

    // MARK: - Test Data

    func createTestGameState() -> GameState {
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

    @Test("Generate share text for completed game")
    func generateShareTextForCompletedGame() {
        // Given
        let gameState = createTestGameState()

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        #expect(shareText.contains("白Guessr 🎨"))
        // Score should be formatted with comma separator
        #expect(shareText.contains("4,100"))
        #expect(shareText.contains("5,000"))
        // Should contain round numbers (language-agnostic check)
        #expect(shareText.contains("1:"))
        #expect(shareText.contains("5:"))
        #expect(shareText.contains("https://shiro-guessr.pages.dev/ios"))
        #expect(shareText.contains("#白Guessr"))
    }

    @Test("Generate share text for incomplete game")
    func generateShareTextForIncompleteGame() {
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
        #expect(shareText.isEmpty)
    }

    @Test("Share text contains all rounds")
    func shareTextContainsAllRounds() {
        // Given
        let gameState = createTestGameState()

        // When
        let shareText = ShareService.generateShareText(gameState: gameState)

        // Then
        // Check that each round number appears in the share text
        // Using language-agnostic check (just the round number with colon)
        for round in gameState.rounds {
            #expect(shareText.contains("\(round.roundNumber):"))
        }
    }

    // MARK: - Star Rating Tests

    @Test("Star rating for perfect distance")
    func starRatingForPerfectDistance() {
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
        #expect(shareText.contains("⭐⭐⭐⭐⭐"))
        // Distance 0 should appear in parentheses (language-agnostic)
        #expect(shareText.contains("0)"))
    }

    @Test("Star rating for good distance")
    func starRatingForGoodDistance() {
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
        #expect(shareText.contains("⭐⭐⭐⭐"))
        // Distance 8 should appear in parentheses (language-agnostic)
        #expect(shareText.contains("8)"))
    }

    @Test("Star rating for average distance")
    func starRatingForAverageDistance() {
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
        #expect(shareText.contains("⭐⭐⭐"))
        // Distance 15 should appear in parentheses (language-agnostic)
        #expect(shareText.contains("15)"))
    }

    @Test("Star rating for poor distance")
    func starRatingForPoorDistance() {
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
        #expect(shareText.contains("⭐⭐"))
        // Distance 30 should appear in parentheses (language-agnostic)
        #expect(shareText.contains("30)"))
    }

    @Test("Star rating for very poor distance")
    func starRatingForVeryPoorDistance() {
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
        #expect(shareText.contains("⭐"))
        #expect(!shareText.contains("⭐⭐"))
        // Distance 50 should appear in parentheses (language-agnostic)
        #expect(shareText.contains("50)"))
    }

    // MARK: - Score Formatting Tests

    @Test("Score formatting with commas")
    func scoreFormattingWithCommas() {
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
        #expect(shareText.contains("4,523"))
    }

    @Test("Score formatting without commas")
    func scoreFormattingWithoutCommas() {
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
        #expect(shareText.contains("500"))
    }
}
