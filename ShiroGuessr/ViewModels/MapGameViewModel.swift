import Foundation
import SwiftUI

/// ViewModel for managing map game state and logic
@MainActor
@Observable
final class MapGameViewModel {
    // MARK: - Dependencies

    private let mapGameService: MapGameService
    private let gradientMapService: GradientMapService
    private let timerService: TimerService

    // MARK: - State

    private(set) var gameState: GameState?
    private(set) var currentGradientMap: GradientMap?
    var showingResult = false

    // MARK: - Animation State

    private(set) var isAnimatingResult = false
    private(set) var showTargetPin = false
    private(set) var lineDrawProgress: CGFloat = 0.0
    private var animationTask: Task<Void, Never>?

    // MARK: - Constants

    private let totalRounds = 5
    private let timeLimit = 60

    // MARK: - Computed Properties

    /// Current round
    var currentRound: GameRound? {
        guard let gameState,
              gameState.currentRoundIndex < gameState.rounds.count else {
            return nil
        }
        return gameState.rounds[gameState.currentRoundIndex]
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

    /// Whether a pin has been placed
    var hasPinPlaced: Bool {
        currentRound?.pin != nil
    }

    /// Time remaining from timer service
    var timeRemaining: Int {
        timerService.timeRemaining
    }

    // MARK: - Initialization

    nonisolated init(
        mapGameService: MapGameService = MapGameService(),
        gradientMapService: GradientMapService = GradientMapService(),
        timerService: TimerService = TimerService()
    ) {
        self.mapGameService = mapGameService
        self.gradientMapService = gradientMapService
        self.timerService = timerService
    }

    // MARK: - Public Methods

    /// Starts a new map game
    /// - Parameter startTimer: Whether to start the timer immediately (default: true)
    func startNewGame(startTimer: Bool = true) {
        // Stop any existing timer
        timerService.stopTimer()

        // Create new game state
        gameState = mapGameService.createNewGame(
            totalRounds: totalRounds,
            timeLimit: timeLimit
        )

        // Generate gradient map for first round
        currentGradientMap = gradientMapService.generateGradientMap()

        // Set target color for first round
        if let gradientMap = currentGradientMap, let gameState {
            self.gameState = mapGameService.startRound(
                gameState: gameState,
                gradientMap: gradientMap
            )
        }

        // Reset UI state
        showingResult = false
        animationTask?.cancel()
        animationTask = nil
        resetAnimationState()

        // Start timer if requested, otherwise just set the time
        if startTimer {
            startRoundTimer()
        } else {
            // Set time without starting the timer
            timerService.setTime(seconds: timeLimit) { [weak self] in
                Task { @MainActor in
                    self?.handleTimeout()
                }
            }
        }
    }

    /// Places a pin at the specified coordinate
    /// - Parameter coordinate: The coordinate where to place the pin
    func placePin(at coordinate: MapCoordinate) {
        guard let gameState,
              let currentGradientMap,
              !isRoundSubmitted else {
            return
        }

        self.gameState = mapGameService.placePin(
            gameState: gameState,
            coordinate: coordinate,
            gradientMap: currentGradientMap
        )
    }

    /// Submits the current guess
    func submitGuess() {
        guard let gameState,
              hasPinPlaced,
              !isRoundSubmitted,
              !isAnimatingResult else {
            return
        }

        // Stop the timer
        timerService.stopTimer()

        // Submit with current time remaining
        self.gameState = mapGameService.submitGuess(
            gameState: gameState,
            timeRemaining: timerService.timeRemaining
        )

        // Start result animation sequence
        startResultAnimation()
    }

    /// Proceeds to the next round or completes the game
    func nextRound() {
        guard let gameState else { return }

        // Cancel any running animation
        animationTask?.cancel()
        animationTask = nil

        // Advance to next round
        self.gameState = mapGameService.nextRound(gameState: gameState)

        // Reset result dialog and animation state
        showingResult = false
        resetAnimationState()

        // Check if game is completed
        if let updatedGameState = self.gameState,
           !updatedGameState.isCompleted {
            // Generate new gradient map for next round
            currentGradientMap = gradientMapService.generateGradientMap()

            // Set target color for next round
            if let gradientMap = currentGradientMap {
                self.gameState = mapGameService.startRound(
                    gameState: updatedGameState,
                    gradientMap: gradientMap
                )
            }

            // Start timer for next round
            startRoundTimer()
        } else {
            // Game completed, stop timer
            timerService.stopTimer()
        }
    }

    /// Resets the game to start a new one
    func resetGame() {
        startNewGame()
    }

    /// Pauses the game timer
    func pauseTimer() {
        timerService.pauseTimer()
    }

    /// Resumes the game timer
    func resumeTimer() {
        // If timer is not running and has time remaining, resume or start it
        if !timerService.isRunning && timerService.timeRemaining > 0 {
            timerService.resumeTimer()
        }
    }

    // MARK: - Private Methods

    /// Starts the timer for the current round
    private func startRoundTimer() {
        timerService.startTimer(seconds: timeLimit) { [weak self] in
            Task { @MainActor in
                self?.handleTimeout()
            }
        }
    }

    /// Handles timeout by automatically placing a pin at the center
    private func handleTimeout() {
        guard let gameState,
              let currentGradientMap,
              !isRoundSubmitted else {
            return
        }

        // Handle timeout with automatic pin placement
        self.gameState = mapGameService.handleTimeout(
            gameState: gameState,
            gradientMap: currentGradientMap
        )

        // Start result animation sequence
        startResultAnimation()
    }

    /// Starts the result animation sequence (pin pop-in → dashed line → result sheet)
    private func startResultAnimation() {
        isAnimatingResult = true
        animationTask = Task {
            // Phase 1: Show target pin with spring animation (0ms)
            showTargetPin = true

            // Phase 2: Draw dashed line (180ms delay)
            try? await Task.sleep(for: .milliseconds(180))
            guard !Task.isCancelled else { return }
            lineDrawProgress = 1.0

            // Phase 3: Show result sheet (700ms from start)
            try? await Task.sleep(for: .milliseconds(520))
            guard !Task.isCancelled else { return }
            showingResult = true
            isAnimatingResult = false
        }
    }

    /// Resets animation state for the next round
    private func resetAnimationState() {
        isAnimatingResult = false
        showTargetPin = false
        lineDrawProgress = 0.0
    }
}
