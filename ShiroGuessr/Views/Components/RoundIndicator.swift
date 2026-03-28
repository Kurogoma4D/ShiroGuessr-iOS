import SwiftUI

/// Round progress indicator using dots
/// - Size: 10dp per dot
/// - Completed: fill accentPrimary
/// - Current: ring accentPrimary + pulse animation
/// - Upcoming: ring textMuted (#5C5866)
/// - Spacing: 12dp
struct RoundIndicator: View {
    let currentRound: Int
    let totalRounds: Int

    var body: some View {
        HStack(spacing: 12) {
            if totalRounds > 0 {
                ForEach(1...totalRounds, id: \.self) { round in
                    RoundDot(state: dotState(for: round))
                }
            }
        }
    }

    private func dotState(for round: Int) -> RoundDotState {
        if round < currentRound {
            return .completed
        } else if round == currentRound {
            return .current
        } else {
            return .upcoming
        }
    }
}

// MARK: - Round Dot State

private enum RoundDotState: Equatable {
    case completed
    case current
    case upcoming
}

// MARK: - Round Dot View

private struct RoundDot: View {
    let state: RoundDotState

    @State private var isPulsing = false

    var body: some View {
        Circle()
            .modifier(DotStyleModifier(state: state))
            .frame(width: 10, height: 10)
            .scaleEffect(state == .current && isPulsing ? 1.3 : 1.0)
            .opacity(state == .current && isPulsing ? 0.7 : 1.0)
            .animation(
                state == .current
                    ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                    : .default,
                value: isPulsing
            )
            .onAppear {
                if state == .current {
                    isPulsing = true
                }
            }
            .onChange(of: state) { _, newState in
                isPulsing = (newState == .current)
            }
    }
}

// MARK: - Dot Style Modifier

private struct DotStyleModifier: ViewModifier {
    let state: RoundDotState

    func body(content: Content) -> some View {
        switch state {
        case .completed:
            content
                .foregroundStyle(Color.mdPrimary)
        case .current:
            content
                .foregroundStyle(Color.clear)
                .overlay(
                    Circle()
                        .strokeBorder(Color.mdPrimary, lineWidth: 2)
                )
        case .upcoming:
            content
                .foregroundStyle(Color.clear)
                .overlay(
                    Circle()
                        .strokeBorder(Color.textMuted, lineWidth: 1.5)
                )
        }
    }
}

// MARK: - Preview

#Preview("Round Indicator") {
    VStack(spacing: 24) {
        Text("Round 1 of 5")
            .font(.mdTitleMedium)
            .foregroundStyle(Color.mdOnSurface)
        RoundIndicator(currentRound: 1, totalRounds: 5)

        Text("Round 3 of 5")
            .font(.mdTitleMedium)
            .foregroundStyle(Color.mdOnSurface)
        RoundIndicator(currentRound: 3, totalRounds: 5)

        Text("Round 5 of 5")
            .font(.mdTitleMedium)
            .foregroundStyle(Color.mdOnSurface)
        RoundIndicator(currentRound: 5, totalRounds: 5)

        Text("All Complete (round 6 of 5)")
            .font(.mdTitleMedium)
            .foregroundStyle(Color.mdOnSurface)
        RoundIndicator(currentRound: 6, totalRounds: 5)
    }
    .padding()
    .background(Color.mdBackground)
}
