import XCTest
@testable import ShiroGuessr

final class MapGameServiceTests: XCTestCase {
    var sut: MapGameService!
    var colorService: ColorService!
    var scoreService: ScoreService!
    var gradientMapService: GradientMapService!

    override func setUp() {
        super.setUp()
        colorService = ColorService()
        scoreService = ScoreService()
        gradientMapService = GradientMapService(colorService: colorService)
        sut = MapGameService(
            colorService: colorService,
            scoreService: scoreService,
            gradientMapService: gradientMapService
        )
    }

    override func tearDown() {
        sut = nil
        gradientMapService = nil
        scoreService = nil
        colorService = nil
        super.tearDown()
    }

    // MARK: - createNewGame Tests

    func testCreateNewGame_shouldCreateCorrectNumberOfRounds() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        XCTAssertEqual(gameState.rounds.count, 5)
    }

    func testCreateNewGame_shouldSetTimeLimitCorrectly() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        XCTAssertEqual(gameState.timeLimit, 60)
    }

    func testCreateNewGame_shouldStartAtFirstRound() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        XCTAssertEqual(gameState.currentRoundIndex, 0)
    }

    func testCreateNewGame_shouldNotBeCompleted() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        XCTAssertFalse(gameState.isCompleted)
    }

    func testCreateNewGame_shouldHaveZeroInitialScore() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        XCTAssertEqual(gameState.totalScore, 0)
    }

    func testCreateNewGame_eachRoundShouldHaveTargetPin() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        for round in gameState.rounds {
            XCTAssertNotNil(round.targetPin, "Each round should have a target pin")
        }
    }

    func testCreateNewGame_eachRoundShouldNotHaveUserPin() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        for round in gameState.rounds {
            XCTAssertNil(round.pin, "User pin should not be placed initially")
        }
    }

    func testCreateNewGame_roundNumbersShouldBeSequential() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        for (index, round) in gameState.rounds.enumerated() {
            XCTAssertEqual(round.roundNumber, index + 1)
        }
    }


    // MARK: - placePin Tests

    func testPlacePin_shouldAddPinToCurrentRound() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()
        let coordinate = MapCoordinate(x: 0.5, y: 0.5)

        gameState = sut.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: gradientMap
        )

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        XCTAssertNotNil(currentRound.pin)
        XCTAssertEqual(currentRound.pin?.coordinate, coordinate)
    }

    func testPlacePin_shouldSetCorrectColorAtPin() {
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

        XCTAssertEqual(currentRound.pin?.color, expectedColor)
    }

    func testPlacePin_shouldAllowMovingPin() {
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
        XCTAssertEqual(currentRound.pin?.coordinate, coordinate2)
    }

    // MARK: - submitGuess Tests

    func testSubmitGuess_shouldCalculateDistance() {
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
        XCTAssertNotNil(currentRound.distance)
    }

    func testSubmitGuess_shouldCalculateScore() {
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
        XCTAssertNotNil(currentRound.score)
        XCTAssertGreaterThanOrEqual(currentRound.score!, 0)
        XCTAssertLessThanOrEqual(currentRound.score!, 1000)
    }

    func testSubmitGuess_shouldSetSelectedColor() {
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
        XCTAssertNotNil(currentRound.selectedColor)
    }

    func testSubmitGuess_shouldUpdateTotalScore() {
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

        XCTAssertGreaterThanOrEqual(gameState.totalScore, scoreBefore)
    }

    func testSubmitGuess_shouldStoreTimeRemaining() {
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
        XCTAssertEqual(currentRound.timeRemaining, 42)
    }

    func testSubmitGuess_withoutPin_shouldNotModifyState() {
        let gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gameStateBefore = gameState

        let gameStateAfter = sut.submitGuess(gameState: gameState, timeRemaining: 30)

        XCTAssertEqual(gameStateBefore, gameStateAfter)
    }

    // MARK: - handleTimeout Tests

    func testHandleTimeout_shouldPlacePinAtCenter() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        XCTAssertNotNil(currentRound.pin)
        XCTAssertEqual(currentRound.pin?.coordinate.x, 0.5)
        XCTAssertEqual(currentRound.pin?.coordinate.y, 0.5)
    }

    func testHandleTimeout_shouldSubmitGuessWithZeroTime() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        XCTAssertEqual(currentRound.timeRemaining, 0)
    }

    func testHandleTimeout_shouldCalculateScore() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)
        let gradientMap = gradientMapService.generateGradientMap()

        gameState = sut.handleTimeout(gameState: gameState, gradientMap: gradientMap)

        let currentRound = gameState.rounds[gameState.currentRoundIndex]
        XCTAssertNotNil(currentRound.score)
    }

    // MARK: - nextRound Tests

    func testNextRound_shouldIncrementRoundIndex() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        gameState = sut.nextRound(gameState: gameState)

        XCTAssertEqual(gameState.currentRoundIndex, 1)
    }

    func testNextRound_onLastRound_shouldCompleteGame() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        // Advance through all rounds (0->1, 1->2, 2->3, 3->4, 4->completed)
        for _ in 0..<5 {
            gameState = sut.nextRound(gameState: gameState)
        }

        XCTAssertTrue(gameState.isCompleted)
    }

    func testNextRound_beforeLastRound_shouldNotCompleteGame() {
        var gameState = sut.createNewGame(totalRounds: 5, timeLimit: 60)

        gameState = sut.nextRound(gameState: gameState)

        XCTAssertFalse(gameState.isCompleted)
    }

    func testNextRound_shouldPreserveTotalScore() {
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

        XCTAssertEqual(gameState.totalScore, scoreAfterRound1)
    }
}
