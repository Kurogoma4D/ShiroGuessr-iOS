import SwiftUI

/// Screen for the map mode gameplay
struct MapGameScreen: View {
    var onModeToggle: (() -> Void)? = nil

    @State private var viewModel = MapGameViewModel()
    @State private var hasStartedGame = false

    var body: some View {
        ZStack {
            Color.mdBackground
                .ignoresSafeArea()

            if !hasStartedGame && !TutorialManager.shared.shouldShowTutorial {
                // Show start screen only if tutorial has been seen before
                startScreen
            } else if let gameState = viewModel.gameState {
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
                }
            }
        }
        .onAppear {
            if viewModel.gameState == nil {
                let isTutorialShowing = TutorialManager.shared.shouldShowTutorial

                if isTutorialShowing {
                    // First launch with tutorial: auto-start game without timer
                    hasStartedGame = true
                    viewModel.startNewGame(startTimer: false)
                } else if hasStartedGame {
                    // Play Again scenario: auto-start with timer
                    viewModel.startNewGame(startTimer: true)
                }
                // Otherwise: show start screen (user needs to press start button)
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
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
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

    // MARK: - Start Screen

    @ViewBuilder
    private var startScreen: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            Image(systemName: "map.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.mdSecondary)
                .symbolRenderingMode(.hierarchical)
                .shadow(color: Color.mdShadow, radius: 8, x: 0, y: 4)

            // Title
            Text("白Guessr")
                .font(.mdDisplayMedium)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.bold)

            // Subtitle
            Text(L10n.Home.mapMode)
                .font(.mdHeadlineSmall)
                .foregroundStyle(Color.mdOnSurfaceVariant)

            // Description
            Text(L10n.Home.tagline)
                .font(.mdBodyLarge)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            // Start button
            Button {
                hasStartedGame = true
                // Always start timer when user presses start button
                viewModel.startNewGame(startTimer: true)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                    Text(L10n.Game.startGame)
                }
                .font(.mdLabelLarge)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundStyle(Color.mdOnPrimary)
                .background(Color.mdPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            .shadow(color: Color.mdShadow.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - Previews

#Preview("Game Active") {
    MapGameScreen()
}
