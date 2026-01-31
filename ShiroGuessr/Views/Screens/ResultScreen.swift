import SwiftUI

/// Screen displaying final game results
struct ResultScreen: View {
    let gameState: GameState
    let onReplay: () -> Void

    @State private var animateScore = false
    @State private var animateRounds = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.mdPrimary)
                        .scaleEffect(animateScore ? 1.0 : 0.5)
                        .opacity(animateScore ? 1.0 : 0.0)

                    Text("Game Complete!")
                        .font(.mdHeadlineLarge)
                        .foregroundStyle(Color.mdOnSurface)
                        .fontWeight(.bold)
                        .opacity(animateScore ? 1.0 : 0.0)

                    // Total score
                    VStack(spacing: 4) {
                        Text("Total Score")
                            .font(.mdLabelMedium)
                            .foregroundStyle(Color.mdOnSurfaceVariant)

                        Text("\(gameState.totalScore)")
                            .font(.mdDisplayMedium)
                            .foregroundStyle(Color.mdPrimary)
                            .fontWeight(.bold)

                        Text("out of 5000")
                            .font(.mdBodyMedium)
                            .foregroundStyle(Color.mdOnSurfaceVariant)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.mdPrimaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .scaleEffect(animateScore ? 1.0 : 0.8)
                    .opacity(animateScore ? 1.0 : 0.0)
                }
                .padding(.top, 32)

                // Round results
                VStack(spacing: 12) {
                    Text("Round Results")
                        .font(.mdTitleLarge)
                        .foregroundStyle(Color.mdOnSurface)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .opacity(animateRounds ? 1.0 : 0.0)

                    ForEach(gameState.rounds.indices, id: \.self) { index in
                        RoundResultCard(round: gameState.rounds[index])
                            .opacity(animateRounds ? 1.0 : 0.0)
                            .offset(y: animateRounds ? 0 : 20)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7)
                                    .delay(Double(index) * 0.1),
                                value: animateRounds
                            )
                    }
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        onReplay()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                            Text("Play Again")
                        }
                        .font(.mdLabelLarge)
                    }
                    .buttonStyle(.mdFilled)

                    ShareButton(gameState: gameState)

                    Button {
                        copyToClipboard()
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.clipboard")
                            Text("Copy to Clipboard")
                        }
                        .font(.mdLabelLarge)
                    }
                    .buttonStyle(.mdFilledTonal)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color.mdBackground)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateScore = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                animateRounds = true
            }
        }
    }

    private func copyToClipboard() {
        let text = ShareService.generateShareText(gameState: gameState)
        ShareService.copyToClipboard(text)
    }
}

/// Card displaying a single round result
private struct RoundResultCard: View {
    let round: GameRound

    var body: some View {
        HStack(spacing: 16) {
            // Round number
            Text("\(round.roundNumber)")
                .font(.mdTitleLarge)
                .foregroundStyle(Color.mdOnPrimaryContainer)
                .fontWeight(.bold)
                .frame(width: 40, height: 40)
                .background(Color.mdPrimaryContainer)
                .clipShape(Circle())

            // Color previews
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(round.targetColor.toColor())
                    .frame(width: 36, height: 36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.mdOutlineVariant, lineWidth: 1)
                    )

                Image(systemName: "arrow.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                if let selectedColor = round.selectedColor {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(selectedColor.toColor())
                        .frame(width: 36, height: 36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color.mdOutlineVariant, lineWidth: 1)
                        )
                }
            }

            Spacer()

            // Stats
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    Text("Distance:")
                        .font(.mdBodySmall)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                    Text("\(round.distance ?? 0)")
                        .font(.mdBodyMedium)
                        .foregroundStyle(Color.mdOnSurface)
                        .fontWeight(.medium)
                }

                HStack(spacing: 4) {
                    Text("Score:")
                        .font(.mdBodySmall)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                    Text("\(round.score ?? 0)")
                        .font(.mdBodyMedium)
                        .foregroundStyle(Color.mdPrimary)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(12)
        .background(Color.mdSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.mdShadow, radius: 1, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ResultScreen(
        gameState: GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 248, g: 250, b: 250),
                    distance: 6,
                    score: 800,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 2,
                    targetColor: RGBColor(r: 255, g: 255, b: 255),
                    selectedColor: RGBColor(r: 255, g: 255, b: 255),
                    distance: 0,
                    score: 1000,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 3,
                    targetColor: RGBColor(r: 245, g: 250, b: 248),
                    selectedColor: RGBColor(r: 248, g: 248, b: 250),
                    distance: 7,
                    score: 766,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 4,
                    targetColor: RGBColor(r: 252, g: 245, b: 255),
                    selectedColor: RGBColor(r: 250, g: 248, b: 252),
                    distance: 7,
                    score: 766,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 5,
                    targetColor: RGBColor(r: 248, g: 252, b: 245),
                    selectedColor: RGBColor(r: 250, g: 250, b: 248),
                    distance: 7,
                    score: 766,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 5,
            isCompleted: true,
            totalScore: 4098,
            timeLimit: nil
        ),
        onReplay: {}
    )
}
