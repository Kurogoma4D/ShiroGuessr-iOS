import SwiftUI

/// Screen for the map mode gameplay
struct MapGameScreen: View {
    var onModeToggle: (() -> Void)? = nil

    @State private var viewModel = MapGameViewModel()

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
                        }
                    )
                } else if let currentRound = viewModel.currentRound,
                          let gradientMap = viewModel.currentGradientMap {
                    // Show game view
                    gameView(
                        gameState: gameState,
                        currentRound: currentRound,
                        gradientMap: gradientMap
                    )
                } else {
                    // Loading or initial state
                    startView
                }
            } else {
                // Loading or initial state
                startView
            }
        }
        .onAppear {
            if viewModel.gameState == nil {
                // Start game without timer if tutorial is showing
                let shouldStartTimer = !TutorialManager.shared.shouldShowTutorial
                viewModel.startNewGame(startTimer: shouldStartTimer)
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
            // Header
            GameHeader(onModeButtonTap: {
                onModeToggle?()
            })

            VStack(spacing: 8) {
                // Score board
                ScoreBoard(
                    currentRound: currentRound.roundNumber,
                    totalRounds: gameState.rounds.count,
                    currentScore: gameState.totalScore
                )

                // Timer display
                TimerDisplay(timeRemaining: viewModel.timeRemaining)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)

                // Target color display
                targetColorView(color: currentRound.targetColor)

                // Gradient map view
                GradientMapView(
                    gradientMap: gradientMap,
                    userPin: currentRound.pin,
                    targetPin: viewModel.isRoundSubmitted ? currentRound.targetPin : nil,
                    isInteractionEnabled: !viewModel.isRoundSubmitted,
                    onPinPlacement: { coordinate in
                        viewModel.placePin(at: coordinate)
                    }
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 8)

                // Game controls
                GameControls(
                    canSubmit: viewModel.hasPinPlaced,
                    canProceed: viewModel.isRoundSubmitted,
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

    // MARK: - Target Color View

    @ViewBuilder
    private func targetColorView(color: RGBColor) -> some View {
        VStack(spacing: 6) {
            Text(L10n.Game.findThisColor)
                .font(.mdBodyLarge)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.semibold)

            RoundedRectangle(cornerRadius: 8)
                .fill(color.toColor())
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.mdOutline, lineWidth: 1.5)
                )

            Text(color.toCSSString())
                .font(.mdBodySmall)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .fontDesign(.monospaced)
        }
        .padding(12)
        .background(Color.mdSurfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    // MARK: - Start View

    @ViewBuilder
    private var startView: some View {
        VStack {
            Spacer()

            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.mdPrimary)

            Text(L10n.Game.loading)
                .font(.mdBodyLarge)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .padding(.top, 24)

            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Game Active") {
    MapGameScreen()
}
