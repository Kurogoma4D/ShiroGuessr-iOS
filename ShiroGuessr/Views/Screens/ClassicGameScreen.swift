import SwiftUI

/// Main screen for classic game mode
struct ClassicGameScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var viewModel = GameViewModel()
    var onBackToHome: (() -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mdBackground.ignoresSafeArea()

                if let currentRound = viewModel.currentRound,
                   viewModel.isGameActive {
                    // Active game view
                    VStack(spacing: 0) {
                        // Header with score — mode toggle hidden during gameplay
                        GameHeader(
                            currentScore: viewModel.gameState?.totalScore ?? 0
                        )

                        ScrollableIfNeeded {
                            VStack(spacing: 20) {
                                // Round indicator
                                ScoreBoard(
                                    currentRound: currentRound.roundNumber,
                                    totalRounds: 5
                                )

                                // Target color display — gallery frame style
                                TargetColorFrame(
                                    color: currentRound.targetColor,
                                    height: 80,
                                    showCSSValue: false
                                )
                                .padding(.horizontal, 16)

                                // Color palette
                                ColorPalette(
                                    colors: currentRound.paletteColors,
                                    selectedColor: viewModel.selectedColor,
                                    onColorSelected: { color in
                                        viewModel.selectColor(color)
                                    },
                                    isEnabled: !viewModel.isRoundSubmitted
                                )
                                .padding(.horizontal, 16)

                                // Controls
                                GameControls(
                                    canSubmit: viewModel.hasSelectedColor && !viewModel.isRoundSubmitted,
                                    canProceed: viewModel.isRoundSubmitted,
                                    onSubmit: {
                                        viewModel.submitAnswer()
                                    },
                                    onNext: {
                                        viewModel.nextRound()
                                    }
                                )

                                Spacer(minLength: 20)
                            }
                        }
                    }
                } else if let gameState = viewModel.gameState,
                          gameState.isCompleted {
                    // Game completed - show result screen
                    ResultScreen(
                        gameState: gameState,
                        onReplay: {
                            viewModel.resetGame()
                        },
                        onBackToHome: onBackToHome
                    )
                } else {
                    // Loading state — game starts immediately
                    ProgressView()
                        .tint(Color.mdPrimary)
                }
            }
            .navigationBarHidden(true)
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
    }
}

#Preview {
    ClassicGameScreen()
}
