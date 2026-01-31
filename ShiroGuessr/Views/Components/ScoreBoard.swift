import SwiftUI

/// Component displaying current round and score information
struct ScoreBoard: View {
    let currentRound: Int
    let totalRounds: Int
    let currentScore: Int

    var body: some View {
        HStack(spacing: 24) {
            // Round indicator
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
                    .font(.mdTitleLarge)
                    .foregroundStyle(Color.mdPrimary)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.mdSurfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
