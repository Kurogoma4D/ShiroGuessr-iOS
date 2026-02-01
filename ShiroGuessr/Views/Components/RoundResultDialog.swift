import SwiftUI

/// Dialog displaying the result of a single round
struct RoundResultDialog: View {
    let round: GameRound
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Header
            Text(L10n.RoundResult.title(round.roundNumber))
                .font(.mdHeadlineMedium)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.bold)

            // Color comparison
            HStack(spacing: 24) {
                // Target color
                VStack(spacing: 8) {
                    Text(L10n.RoundResult.target)
                        .font(.mdLabelMedium)
                        .foregroundStyle(Color.mdOnSurfaceVariant)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(round.targetColor.toColor())
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.mdOutline, lineWidth: 1)
                        )

                    Text(round.targetColor.toCSSString())
                        .font(.mdBodySmall)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                        .fontDesign(.monospaced)
                }

                // Selected color
                VStack(spacing: 8) {
                    Text(L10n.RoundResult.yourGuess)
                        .font(.mdLabelMedium)
                        .foregroundStyle(Color.mdOnSurfaceVariant)

                    if let selectedColor = round.selectedColor {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor.toColor())
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.mdOutline, lineWidth: 1)
                            )

                        Text(selectedColor.toCSSString())
                            .font(.mdBodySmall)
                            .foregroundStyle(Color.mdOnSurfaceVariant)
                            .fontDesign(.monospaced)
                    }
                }
            }

            // Stats
            VStack(spacing: 12) {
                // Distance
                HStack {
                    Text(L10n.RoundResult.distance)
                        .font(.mdBodyLarge)
                        .foregroundStyle(Color.mdOnSurface)
                    Spacer()
                    Text("\(round.distance ?? 0)")
                        .font(.mdTitleMedium)
                        .foregroundStyle(Color.mdOnSurface)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)

                Divider()
                    .background(Color.mdOutlineVariant)
                    .padding(.horizontal, 20)

                // Score
                HStack {
                    Text(L10n.RoundResult.score)
                        .font(.mdBodyLarge)
                        .foregroundStyle(Color.mdOnSurface)
                    Spacer()
                    Text("\(round.score ?? 0)")
                        .font(.mdTitleLarge)
                        .foregroundStyle(Color.mdPrimary)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
            .background(Color.mdSurfaceVariant.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Next button
            Button {
                onNext()
            } label: {
                HStack {
                    Text(L10n.RoundResult.continue)
                    Image(systemName: "arrow.right.circle.fill")
                }
                .font(.mdLabelLarge)
            }
            .buttonStyle(.mdFilled)
        }
        .padding(24)
        .background(Color.mdSurface)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: Color.mdShadow, radius: 8, x: 0, y: 4)
        .padding(24)
    }
}

#Preview {
    ZStack {
        Color.mdScrim.ignoresSafeArea()

        RoundResultDialog(
            round: GameRound(
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
            onNext: {}
        )
    }
}
