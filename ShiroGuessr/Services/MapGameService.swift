import Foundation

/// Service for managing map mode game logic
final class MapGameService {
    // MARK: - Dependencies

    private let colorService: ColorService
    private let scoreService: ScoreService
    private let gradientMapService: GradientMapService

    // MARK: - Initialization

    init(
        colorService: ColorService = ColorService(),
        scoreService: ScoreService = ScoreService(),
        gradientMapService: GradientMapService = GradientMapService()
    ) {
        self.colorService = colorService
        self.scoreService = scoreService
        self.gradientMapService = gradientMapService
    }

    // MARK: - Public Methods

    /// Creates a new map game state with specified rounds and time limit
    /// - Parameters:
    ///   - totalRounds: Number of rounds to play (default: 5)
    ///   - timeLimit: Time limit per round in seconds (default: 60)
    /// - Returns: A new GameState configured for map mode
    func createNewGame(totalRounds: Int = 5, timeLimit: Int = 60) -> GameState {
        var rounds: [GameRound] = []

        for roundNumber in 1...totalRounds {
            // Generate gradient map for this round
            let gradientMap = gradientMapService.generateGradientMap()

            // Generate random target coordinate
            let targetCoordinate = MapCoordinate(
                x: Double.random(in: 0...1),
                y: Double.random(in: 0...1)
            )

            // Get the target color at that coordinate
            let targetColor = gradientMapService.getColorAt(
                map: gradientMap,
                coordinate: targetCoordinate
            )

            // Create target pin
            let targetPin = Pin(
                coordinate: targetCoordinate,
                color: targetColor
            )

            rounds.append(GameRound(
                roundNumber: roundNumber,
                targetColor: targetColor,
                selectedColor: nil,
                distance: nil,
                score: nil,
                paletteColors: [],
                pin: nil,
                targetPin: targetPin,
                timeRemaining: nil
            ))
        }

        return GameState(
            rounds: rounds,
            currentRoundIndex: 0,
            isCompleted: false,
            totalScore: 0,
            timeLimit: timeLimit
        )
    }

    /// Places a pin at the specified coordinate
    /// - Parameters:
    ///   - gameState: Current game state
    ///   - coordinate: Coordinate where to place the pin
    ///   - gradientMap: The gradient map for the current round
    /// - Returns: Updated game state with the pin placed
    func placePin(
        gameState: GameState,
        coordinate: MapCoordinate,
        gradientMap: GradientMap
    ) -> GameState {
        guard gameState.currentRoundIndex < gameState.rounds.count else {
            return gameState
        }

        let currentRound = gameState.rounds[gameState.currentRoundIndex]

        // Get color at the pin location
        let pinColor = gradientMapService.getColorAt(map: gradientMap, coordinate: coordinate)

        // Create pin
        let pin = Pin(coordinate: coordinate, color: pinColor)

        // Update the current round with the pin
        var updatedRounds = gameState.rounds
        updatedRounds[gameState.currentRoundIndex] = GameRound(
            roundNumber: currentRound.roundNumber,
            targetColor: currentRound.targetColor,
            selectedColor: currentRound.selectedColor,
            distance: currentRound.distance,
            score: currentRound.score,
            paletteColors: currentRound.paletteColors,
            pin: pin,
            targetPin: currentRound.targetPin,
            timeRemaining: currentRound.timeRemaining
        )

        return GameState(
            rounds: updatedRounds,
            currentRoundIndex: gameState.currentRoundIndex,
            isCompleted: gameState.isCompleted,
            totalScore: gameState.totalScore,
            timeLimit: gameState.timeLimit
        )
    }

    /// Submits the current guess and calculates the score
    /// - Parameters:
    ///   - gameState: Current game state
    ///   - timeRemaining: Time remaining when guess was submitted
    /// - Returns: Updated game state with score calculated
    func submitGuess(gameState: GameState, timeRemaining: Int) -> GameState {
        guard gameState.currentRoundIndex < gameState.rounds.count else {
            return gameState
        }

        let currentRound = gameState.rounds[gameState.currentRoundIndex]

        // Ensure pin is placed
        guard let pin = currentRound.pin else {
            return gameState
        }

        // Calculate distance and score
        let distance = colorService.calculateManhattanDistance(
            currentRound.targetColor,
            pin.color
        )
        let score = scoreService.calculateRoundScore(distance: distance)

        // Update the current round
        var updatedRounds = gameState.rounds
        updatedRounds[gameState.currentRoundIndex] = GameRound(
            roundNumber: currentRound.roundNumber,
            targetColor: currentRound.targetColor,
            selectedColor: pin.color,
            distance: distance,
            score: score,
            paletteColors: currentRound.paletteColors,
            pin: pin,
            targetPin: currentRound.targetPin,
            timeRemaining: timeRemaining
        )

        // Calculate new total score
        let totalScore = scoreService.calculateTotalScore(rounds: updatedRounds)

        return GameState(
            rounds: updatedRounds,
            currentRoundIndex: gameState.currentRoundIndex,
            isCompleted: gameState.isCompleted,
            totalScore: totalScore,
            timeLimit: gameState.timeLimit
        )
    }

    /// Handles timeout by placing a pin at the center of the map
    /// - Parameters:
    ///   - gameState: Current game state
    ///   - gradientMap: The gradient map for the current round
    /// - Returns: Updated game state with automatic pin placement and score
    func handleTimeout(gameState: GameState, gradientMap: GradientMap) -> GameState {
        // Place pin at center
        let centerCoordinate = MapCoordinate(x: 0.5, y: 0.5)
        let stateWithPin = placePin(
            gameState: gameState,
            coordinate: centerCoordinate,
            gradientMap: gradientMap
        )

        // Submit with 0 time remaining
        return submitGuess(gameState: stateWithPin, timeRemaining: 0)
    }

    /// Advances to the next round
    /// - Parameter gameState: Current game state
    /// - Returns: Updated game state with next round active or game completed
    func nextRound(gameState: GameState) -> GameState {
        let nextIndex = gameState.currentRoundIndex + 1
        let isCompleted = nextIndex >= gameState.rounds.count

        return GameState(
            rounds: gameState.rounds,
            currentRoundIndex: nextIndex,
            isCompleted: isCompleted,
            totalScore: gameState.totalScore,
            timeLimit: gameState.timeLimit
        )
    }
}
