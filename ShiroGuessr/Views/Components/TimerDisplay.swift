import SwiftUI

/// Displays the remaining time in MM:SS format with visual warning for low time
struct TimerDisplay: View {
    /// Remaining time in seconds
    let timeRemaining: Int

    /// Warning threshold in seconds (default: 10)
    var warningThreshold: Int = 10

    // MARK: - Computed Properties

    /// Formats time as MM:SS
    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Whether to show warning state
    private var isWarning: Bool {
        timeRemaining <= warningThreshold && timeRemaining > 0
    }

    /// Whether time has run out
    private var isTimeout: Bool {
        timeRemaining == 0
    }

    /// Color for the timer display
    private var timerColor: Color {
        if isTimeout {
            return .red
        } else if isWarning {
            return .orange
        } else {
            return .primary
        }
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.title2)

            Text(formattedTime)
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.medium)
        }
        .foregroundColor(timerColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(timerColor.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(timerColor.opacity(0.3), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: timerColor)
    }
}

// MARK: - Previews

#Preview("Normal") {
    TimerDisplay(timeRemaining: 45)
        .padding()
}

#Preview("Warning") {
    TimerDisplay(timeRemaining: 8)
        .padding()
}

#Preview("Timeout") {
    TimerDisplay(timeRemaining: 0)
        .padding()
}
