import SwiftUI

/// Main screen for classic game mode
struct ClassicGameScreen: View {
    var onModeToggle: (() -> Void)? = nil

    @State private var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mdBackground.ignoresSafeArea()

                if let currentRound = viewModel.currentRound,
                   viewModel.isGameActive {
                    // Active game view
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            GameHeader(onModeButtonTap: {
                                onModeToggle?()
                            })

                            // Score board
                            ScoreBoard(
                                currentRound: currentRound.roundNumber,
                                totalRounds: 5,
                                currentScore: viewModel.gameState?.totalScore ?? 0
                            )

                            // Target color display
                            VStack(spacing: 12) {
                                Text(L10n.Game.findThisColorColon)
                                    .font(.mdTitleMedium)
                                    .foregroundStyle(Color.mdOnSurface)

                                RoundedRectangle(cornerRadius: 16)
                                    .fill(currentRound.targetColor.toColor())
                                    .frame(height: 200)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.mdOutline, lineWidth: 2)
                                    )
                                    .shadow(color: Color.mdShadow, radius: 4, x: 0, y: 2)
                                    .padding(.horizontal, 16)
                            }

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
                } else if let gameState = viewModel.gameState,
                          gameState.isCompleted {
                    // Game completed - navigate to result screen
                    ResultScreen(
                        gameState: gameState,
                        onReplay: {
                            viewModel.resetGame()
                        }
                    )
                } else {
                    // Initial state - show start screen
                    VStack(spacing: 24) {
                        Spacer()

                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(Color.mdPrimary)

                        Text("白Guessr")
                            .font(.mdDisplayMedium)
                            .foregroundStyle(Color.mdOnSurface)
                            .fontWeight(.bold)

                        Text(L10n.Home.tagline)
                            .font(.mdBodyLarge)
                            .foregroundStyle(Color.mdOnSurfaceVariant)

                        Spacer()

                        Button {
                            viewModel.startNewGame()
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text(L10n.Game.startGame)
                            }
                            .font(.mdLabelLarge)
                        }
                        .buttonStyle(.mdFilled)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showingResult) {
                if let currentRound = viewModel.currentRound {
                    RoundResultDialog(
                        round: currentRound,
                        onNext: {
                            viewModel.nextRound()
                        }
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

#Preview {
    ClassicGameScreen()
}
