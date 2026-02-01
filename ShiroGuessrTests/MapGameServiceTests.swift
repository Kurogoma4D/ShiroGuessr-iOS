import Testing
@testable import ShiroGuessr

@Suite("MapGameService Tests")
struct MapGameServiceTests {

    // MARK: - createNewGame Tests

    @Test("Create new game should create correct number of rounds")
    func createNewGame_shouldCreateCorrectNumberOfRounds() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        #expect(gameState.rounds.count == 5)
    }

    @Test("Create new game should set time limit correctly")
    func createNewGame_shouldSetTimeLimitCorrectly() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        #expect(gameState.timeLimit == 60)
    }

    @Test("Create new game should start at first round")
    func createNewGame_shouldStartAtFirstRound() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        #expect(gameState.currentRoundIndex == 0)
    }

    @Test("Create new game should not be completed")
    func createNewGame_shouldNotBeCompleted() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        #expect(!gameState.isCompleted)
    }

    @Test("Create new game should have zero initial score")
    func createNewGame_shouldHaveZeroInitialScore() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        #expect(gameState.totalScore == 0)
    }

    @Test("Each round should have target pin after start")
    func startRound_shouldSetTargetPin() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        // Start the first round
        gameState = sut.startRound(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.targetPin != nil)
    }

    @Test("Each round should not have user pin")
    func createNewGame_eachRoundShouldNotHaveUserPin() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        for round in gameState.rounds {
            #expect(round.pin == nil)
        }
    }

    @Test("Round numbers should be sequential")
    func createNewGame_roundNumbersShouldBeSequential() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        for (index, round) in gameState.rounds.enumerated() {
            #expect(round.roundNumber == index + 1)
        }
    }


    // MARK: - placePin Tests

    @Test("Place pin should add pin to current round")
    func placePin_shouldAddPinToCurrentRound() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.pin != nil)
        #expect(currentRound.pin?.coordinate == coordinate)
    }

    @Test("Place pin should set correct color at pin")
    func placePin_shouldSetCorrectColorAtPin() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        let expectedColor = gradientMapService.getColorAt(map: gradientMap, coordinate: coordinate)
        let currentRound = gameState.rounds[gameState.currentRoundIndex]

        #expect(currentRound.pin?.color == expectedColor)
    }

    @Test("Place pin should allow moving pin")
    func placePin_shouldAllowMovingPin() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        // Place first pin
        let coordinate1 = MapCoordinate(x: 0.3, y: 0.3)
        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate1,
            gradientMap: gradientMap
        )

        // Move pin
        let coordinate2 = MapCoordinate(x: 0.7, y: 0.7)
        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate2,
            gradientMap: gradientMap
        )

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.pin?.coordinate == coordinate2)
    }

    // MARK: - submitGuess Tests

    @Test("Submit guess should calculate distance")
    func submitGuess_shouldCalculateDistance() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.distance != nil)
    }

    @Test("Submit guess should calculate score")
    func submitGuess_shouldCalculateScore() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.score != nil)
        #expect(currentRound.score! >= 0)
        #expect(currentRound.score! <= 1000)
    }

    @Test("Submit guess should set selected color")
    func submitGuess_shouldSetSelectedColor() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.selectedColor != nil)
    }

    @Test("Submit guess should update total score")
    func submitGuess_shouldUpdateTotalScore() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        let scoreBefore = gameState.totalScore
        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        #expect(gameState.totalScore >= scoreBefore)
    }

    @Test("Submit guess should store time remaining")
    func submitGuess_shouldStoreTimeRemaining() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 42)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.timeRemaining == 42)
    }

    @Test("Submit guess without pin should not modify state")
    func submitGuess_withoutPin_shouldNotModifyState() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gameStateBefore = gameState

        let gameStateAfter = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        #expect(gameStateBefore == gameStateAfter)
    }

    // MARK: - handleTimeout Tests

    @Test("Handle timeout should place pin at center")
    func handleTimeout_shouldPlacePinAtCenter() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.pin != nil)
        #expect(currentRound.pin?.coordinate.x == 0.5)
        #expect(currentRound.pin?.coordinate.y == 0.5)
    }

    @Test("Handle timeout should submit guess with zero time")
    func handleTimeout_shouldSubmitGuessWithZeroTime() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.timeRemaining == 0)
    }

    @Test("Handle timeout should calculate score")
    func handleTimeout_shouldCalculateScore() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        #expect(currentRound.score != nil)
    }

    // MARK: - nextRound Tests

    @Test("Next round should increment round index")
    func nextRound_shouldIncrementRoundIndex() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        gameState = sut.nextRound(gameState: gameState)

        #expect(gameState.currentRoundIndex == 1)
    }

    @Test("Next round on last round should complete game")
    func nextRound_onLastRound_shouldCompleteGame() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        // Advance through all rounds (0->1, 1->2, 2->3, 3->4, 4->completed)
        for _ in 0..<5 {
            gameState = sut.nextRound(gameState: gameState)
        }

        #expect(gameState.isCompleted)
    }

    @Test("Next round before last round should not complete game")
    func nextRound_beforeLastRound_shouldNotCompleteGame() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        gameState = sut.nextRound(gameState: gameState)

        #expect(!gameState.isCompleted)
    }

    @Test("Next round should preserve total score")
    func nextRound_shouldPreserveTotalScore() {
        let colorService = ColorService()
        let scoreService = ScoreService()
        let gradientMapService = GradientMapService(colorService: colorService)
        let sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )

        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        // Complete first round
        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )
        gameState = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        let scoreAfterRound1 = gameState.totalScore
        gameState = sut.nextRound(gameState: gameState)

        #expect(gameState.totalScore == scoreAfterRound1)
    }
}
