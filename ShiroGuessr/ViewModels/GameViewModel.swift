import Foundation
import SwiftUI

/// ViewModel for managing classic game state and logic
@MainActor
@Observable
final class GameViewModel {
    // MARK: - Dependencies
    private let colorService: ColorService
    private let scoreService: ScoreService

    // MARK: - State
    private(set) var gameState: GameState?
    private(set) var selectedColor: RGBColor?
    var showingResult = false

    // MARK: - Constants
    private let totalRounds = 5

    // MARK: - Computed Properties

    /// Current round (1-based index)
    var currentRound: GameRound? {
        guard let gameState,
              gameState.currentRoundIndex < gameState.rounds.count else {
            return nil
        }
        return gameState.rounds[gameState.currentRoundIndex]
    }

    /// Whether a color has been selected
    var hasSelectedColor: Bool {
        selectedColor != nil
    }

    /// Whether the current round has been submitted
    var isRoundSubmitted: Bool {
        currentRound?.selectedColor != nil
    }

    /// Whether the game is active (not completed)
    var isGameActive: Bool {
        guard let gameState else { return false }
        return !gameState.isCompleted
    }

    // MARK: - Initialization

    nonisolated init(colorService: ColorService = ColorService(),
                     scoreService: ScoreService = ScoreService()) {
        self.colorService = colorService
        self.scoreService = scoreService
    }

    // MARK: - Public Methods

    /// Starts a new game with fresh rounds
    func startNewGame() {
        var rounds: [GameRound] = []

        // Generate rounds
        for roundNumber in 1...totalRounds {
            let targetColor = colorService.generateRandomWhiteColor()
            let paletteColors = colorService.getRandomPaletteColors(count: 25)

            rounds.append(GameRound(
                roundNumber: roundNumber,
                targetColor: targetColor,
                selectedColor: nil,
                distance: nil,
                score: nil,
                paletteColors: paletteColors,
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ))
        }

        gameState = GameState(
            rounds: rounds,
            currentRoundIndex: 0,
            isCompleted: false,
            totalScore: 0,
            timeLimit: nil
        )

        selectedColor = nil
        showingResult = false
    }

    /// Selects a color from the palette
    /// - Parameter color: The color to select
    func selectColor(_ color: RGBColor) {
        guard isGameActive, !isRoundSubmitted else { return }
        selectedColor = color
    }

    /// Submits the selected color and calculates the score
    func submitAnswer() {
        guard let gameState,
              let selectedColor,
              let currentRound,
              !isRoundSubmitted else {
            return
        }

        // Calculate distance and score
        let distance = colorService.calculateManhattanDistance(
            currentRound.targetColor,
            selectedColor
        )
        let score = scoreService.calculateRoundScore(distance: distance)

        // Update the current round
        var updatedRounds = gameState.rounds
        updatedRounds[gameState.currentRoundIndex] = GameRound(
            roundNumber: currentRound.roundNumber,
            targetColor: currentRound.targetColor,
            selectedColor: selectedColor,
            distance: distance,
            score: score,
            paletteColors: currentRound.paletteColors,
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        )

        // Calculate new total score
        let totalScore = scoreService.calculateTotalScore(rounds: updatedRounds)

        // Update game state
        self.gameState = GameState(
            rounds: updatedRounds,
            currentRoundIndex: gameState.currentRoundIndex,
            isCompleted: gameState.isCompleted,
            totalScore: totalScore,
            timeLimit: nil
        )

        // Show result dialog
        showingResult = true
    }

    /// Proceeds to the next round or completes the game
    func nextRound() {
        guard let gameState else { return }

        let nextIndex = gameState.currentRoundIndex + 1
        let isCompleted = nextIndex >= gameState.rounds.count

        self.gameState = GameState(
            rounds: gameState.rounds,
            currentRoundIndex: nextIndex,
            isCompleted: isCompleted,
            totalScore: gameState.totalScore,
            timeLimit: nil
        )

        // Reset selection for next round
        selectedColor = nil
        showingResult = false
    }

    /// Resets the game to start a new one
    func resetGame() {
        startNewGame()
    }
}
