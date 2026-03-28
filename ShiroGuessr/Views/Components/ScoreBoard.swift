import SwiftUI

/// Component displaying current round and score information
/// Uses card/panel style: canvasElevated background, 16dp radius, 1dp border, shadow
struct ScoreBoard: View {
    let currentRound: Int
    let totalRounds: Int
    let currentScore: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                // Round text
                VStack(alignment: .leading, spacing: 4) {
                    Text("Round")
                        .font(.mdLabelMedium)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                    Text("\(currentRound)/\(totalRounds)")
                        .font(.mdTitleLarge)
                        .foregroundStyle(Color.mdOnSurface)
                        .fontWeight(.semibold)
                }

                Divider()
                    .frame(height: 44)
                    .background(Color.mdOutlineVariant)

                // Score display
                VStack(alignment: .leading, spacing: 4) {
                    Text("Score")
                        .font(.mdLabelMedium)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                    Text("\(currentScore)")
                        .font(.mdDisplaySmall)
                        .foregroundStyle(Color.mdPrimary)
                        .tabularFigures()
                }

                Spacer()
            }

            // Round indicator dots
            RoundIndicator(currentRound: currentRound, totalRounds: totalRounds)
        }
        .padding(16)
        .cardPanelStyle()
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 16) {
        ScoreBoard(currentRound: 1, totalRounds: 5, currentScore: 0)
        ScoreBoard(currentRound: 3, totalRounds: 5, currentScore: 2450)
        ScoreBoard(currentRound: 5, totalRounds: 5, currentScore: 4800)
    }
    .padding()
    .background(Color.mdBackground)
}
