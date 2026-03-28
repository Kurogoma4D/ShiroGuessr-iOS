import SwiftUI

/// Minimal header component for gameplay screens.
/// Shows a small logo mark on the left and an optional gold score display on the right.
/// Mode toggle is intentionally omitted during gameplay (available only on start/result screens).
struct GameHeader: View {
    /// Current score to display. When nil, the score area is hidden.
    var currentScore: Int? = nil

    /// Controls the bounce animation scale effect.
    @State private var scoreBounce: Bool = false

    var body: some View {
        HStack {
            // Small logo mark — minimal branding during gameplay
            Text("白G")
                .font(.mdHeadlineSmall)
                .foregroundStyle(Color.mdPrimary)
                .fontWeight(.bold)

            Spacer()

            // Persistent gold score display in the top-right
            if let score = currentScore {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.mdPrimary.opacity(0.7))

                    Text("\(score)")
                        .font(.mdDisplaySmall)
                        .foregroundStyle(Color.mdPrimary)
                        .fontWeight(.bold)
                        .tabularFigures()
                }
                .scaleEffect(scoreBounce ? 1.2 : 1.0)
                .animation(AnimationConstants.springBouncy, value: scoreBounce)
                .onChange(of: score) { oldValue, newValue in
                    if newValue > oldValue {
                        triggerBounce()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.mdSurface)
    }

    /// Triggers a bounce animation by toggling the scale effect.
    private func triggerBounce() {
        scoreBounce = true
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            scoreBounce = false
        }
    }
}

#Preview("With Score") {
    VStack(spacing: 0) {
        GameHeader(currentScore: 2450)
        Spacer()
    }
    .background(Color.mdBackground)
}

#Preview("Without Score") {
    VStack(spacing: 0) {
        GameHeader()
        Spacer()
    }
    .background(Color.mdBackground)
}
