import SwiftUI

/// Screen for the map mode gameplay
struct MapGameScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var viewModel = MapGameViewModel()
    var onBackToHome: (() -> Void)?

    var body: some View {
        ZStack {
            Color.mdBackground
                .ignoresSafeArea()

            if let gameState = viewModel.gameState {
                if gameState.isCompleted {
                    // Show result screen
                    ResultScreen(
                        gameState: gameState,
                        onReplay: {
                            viewModel.resetGame()
                        },
                        onBackToHome: onBackToHome
                    )
                } else if let currentRound = viewModel.currentRound,
                          let gradientMap = viewModel.currentGradientMap {
                    // Show game view
                    gameView(
                        gameState: gameState,
                        currentRound: currentRound,
                        gradientMap: gradientMap
                    )
                }
            } else {
                // Loading state — game starts immediately
                ProgressView()
                    .tint(Color.mdPrimary)
            }
        }
        .onAppear {
            if viewModel.gameState == nil {
                let isTutorialShowing = TutorialManager.shared.shouldShowTutorial

                if isTutorialShowing {
                    // First launch with tutorial: auto-start game without timer
                    viewModel.startNewGame(startTimer: false)
                } else {
                    // Normal start: begin game with timer
                    viewModel.startNewGame(startTimer: true)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .pauseGameTimer)) { _ in
            viewModel.pauseTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .resumeGameTimer)) { _ in
            viewModel.resumeTimer()
        }
        .sheet(isPresented: $viewModel.showingResult) {
            if let currentRound = viewModel.currentRound {
                RoundResultDialog(
                    round: currentRound,
                    onNext: {
                        viewModel.showingResult = false
                        viewModel.nextRound()
                    }
                )
                .presentationDetents([.medium, .large],
                    selection: .constant(horizontalSizeClass == .regular ? .large : .medium))
                .presentationDragIndicator(.visible)
                .modifier(FormPresentationSizingModifier())
            }
        }
    }

    // MARK: - Game View

    @ViewBuilder
    private func gameView(
        gameState: GameState,
        currentRound: GameRound,
        gradientMap: GradientMap
    ) -> some View {
        VStack(spacing: 0) {
            // Header with score — mode toggle hidden during gameplay
            GameHeader(
                currentScore: gameState.totalScore
            )

            ScrollableIfNeeded {
                VStack(spacing: 8) {
                    // Round indicator
                    ScoreBoard(
                        currentRound: currentRound.roundNumber,
                        totalRounds: gameState.rounds.count
                    )

                    // Timer display
                    TimerDisplay(timeRemaining: viewModel.timeRemaining)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16)

                    // Target color display
                    targetColorView(color: currentRound.targetColor)

                    // Gradient map view with adaptive sizing
                    // Map is the star of this mode — use a larger ratio of screen width
                    GeometryReader { geometry in
                        let availableWidth = geometry.size.width
                        let mapSize: CGFloat = horizontalSizeClass == .regular
                            ? min(availableWidth, 560)
                            : min(availableWidth, 400)

                        GradientMapView(
                            gradientMap: gradientMap,
                            userPin: currentRound.pin,
                            targetPin: viewModel.isRoundSubmitted ? currentRound.targetPin : nil,
                            showTargetPinAnimated: viewModel.showTargetPin,
                            lineDrawProgress: viewModel.lineDrawProgress,
                            mapSize: mapSize,
                            isInteractionEnabled: !viewModel.isRoundSubmitted && !viewModel.isAnimatingResult,
                            onPinPlacement: { coordinate in
                                viewModel.placePin(at: coordinate)
                            }
                        )
                        .frame(width: mapSize, height: mapSize)
                        .frame(maxWidth: .infinity)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 8)

                    // Game controls
                    GameControls(
                        canSubmit: viewModel.hasPinPlaced && !viewModel.isAnimatingResult,
                        canProceed: viewModel.isRoundSubmitted && !viewModel.isAnimatingResult,
                        onSubmit: {
                            viewModel.submitGuess()
                        },
                        onNext: {
                            viewModel.nextRound()
                        }
                    )
                    .padding(.bottom, 16)
                }
            }
        }
    }

    // MARK: - Target Color View

    @ViewBuilder
    private func targetColorView(color: RGBColor) -> some View {
        TargetColorFrame(
            color: color,
            height: 50,
            showCSSValue: false
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews

#Preview("Game Active") {
    MapGameScreen()
}
