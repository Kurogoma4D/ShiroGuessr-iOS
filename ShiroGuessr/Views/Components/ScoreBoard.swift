import SwiftUI

/// Component displaying round progress using dot indicators.
/// Score display has been moved to GameHeader as a persistent gold-colored hero element.
struct ScoreBoard: View {
    let currentRound: Int
    let totalRounds: Int

    var body: some View {
        HStack(spacing: 12) {
            Text("Round")
                .font(.mdLabelMedium)
                .foregroundStyle(Color.mdOnSurfaceVariant)

            RoundIndicator(currentRound: currentRound, totalRounds: totalRounds)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack(spacing: 16) {
        ScoreBoard(currentRound: 1, totalRounds: 5)
        ScoreBoard(currentRound: 3, totalRounds: 5)
        ScoreBoard(currentRound: 5, totalRounds: 5)
    }
    .padding()
    .background(Color.mdBackground)
}
