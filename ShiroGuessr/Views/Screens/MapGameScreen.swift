import SwiftUI

/// Screen for the map mode gameplay
struct MapGameScreen: View {
    @State private var viewModel = MapGameViewModel()

    var body: some View {
        ZStack {
            Color.mdBackground
                .ignoresSafeArea()

            if let gameState = viewModel.gameState {
                if gameState.isCompleted {
                    // Show result screen
                    resultView(gameState: gameState)
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
                viewModel.startNewGame()
            }
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
            GameHeader()

            ScrollView {
                VStack(spacing: 16) {
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
    }

    // MARK: - Target Color View

    @ViewBuilder
    private func targetColorView(color: RGBColor) -> some View {
        VStack(spacing: 12) {
            Text("Find this color on the map")
                .font(.mdTitleMedium)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.semibold)

            RoundedRectangle(cornerRadius: 12)
                .fill(color.toColor())
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.mdOutline, lineWidth: 2)
                )

            Text(color.toCSSString())
                .font(.mdBodyMedium)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .fontDesign(.monospaced)
        }
        .padding(16)
        .background(Color.mdSurfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    // MARK: - Result View

    @ViewBuilder
    private func resultView(gameState: GameState) -> some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Text("Game Complete!")
                    .font(.mdHeadlineLarge)
                    .foregroundStyle(Color.mdOnSurface)
                    .fontWeight(.bold)

                Text("Final Score")
                    .font(.mdTitleMedium)
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                Text("\(gameState.totalScore)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mdPrimary)

                Text("out of 5000")
                    .font(.mdBodyLarge)
                    .foregroundStyle(Color.mdOnSurfaceVariant)
            }
            .padding(32)
            .background(Color.mdSurfaceVariant.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)

            Spacer()

            // Play again button
            Button(action: {
                viewModel.resetGame()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.mdLabelLarge)
                    Text("Play Again")
                        .font(.mdLabelLarge)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(Color.mdOnPrimary)
                .background(Color.mdPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Start View

    @ViewBuilder
    private var startView: some View {
        VStack {
            Spacer()

            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.mdPrimary)

            Text("Loading...")
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
