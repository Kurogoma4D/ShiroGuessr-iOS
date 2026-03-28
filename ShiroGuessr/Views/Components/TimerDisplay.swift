import SwiftUI

/// Displays the remaining time in MM:SS format with visual warning effects for low time.
///
/// Enhanced effects:
/// - At 10 seconds remaining: timer digits begin pulsing (scale oscillation)
/// - At 5 seconds remaining: color shifts to red and pulse speed increases
/// - A thin linear progress bar below the digits shrinks in sync with remaining time
struct TimerDisplay: View {
    /// Remaining time in seconds
    let timeRemaining: Int

    /// Total time for the timer (used to calculate progress bar ratio)
    var totalTime: Int = 60

    /// Warning threshold in seconds (default: 10)
    var warningThreshold: Int = 10

    /// Critical threshold in seconds (default: 5)
    var criticalThreshold: Int = 5

    // MARK: - Animation State

    @State private var pulseScale: CGFloat = 1.0

    // MARK: - Computed Properties

    /// Formats time as MM:SS
    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Whether to show warning state (10s or less)
    private var isWarning: Bool {
        timeRemaining <= warningThreshold && timeRemaining > 0
    }

    /// Whether to show critical state (5s or less)
    private var isCritical: Bool {
        timeRemaining <= criticalThreshold && timeRemaining > 0
    }

    /// Whether time has run out
    private var isTimeout: Bool {
        timeRemaining == 0
    }

    /// Color for the timer display
    private var timerColor: Color {
        if isTimeout {
            return .timerCritical
        } else if isCritical {
            return .timerCritical
        } else if isWarning {
            return .timerWarning
        } else {
            return .mdOnSurface
        }
    }

    /// Progress ratio (1.0 = full, 0.0 = empty)
    private var progress: CGFloat {
        guard totalTime > 0 else { return 0 }
        return CGFloat(timeRemaining) / CGFloat(totalTime)
    }

    /// Color for the progress bar
    private var progressBarColor: Color {
        if isCritical || isTimeout {
            return .timerCritical
        } else if isWarning {
            return .timerWarning
        } else {
            return .mdPrimary
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 6) {
            // Timer digits
            HStack(spacing: 8) {
                Image(systemName: "timer")
                    .font(.title)

                Text(formattedTime)
                    .font(.custom("JetBrainsMono-Regular", size: 28))
                    .tabularFigures()
            }
            .foregroundColor(timerColor)
            .scaleEffect(pulseScale)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(timerColor.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(timerColor.opacity(0.3), lineWidth: 1)
            )

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(Color.mdSurfaceVariant)
                        .frame(height: 3)

                    // Fill
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(progressBarColor)
                        .frame(width: geometry.size.width * progress, height: 3)
                        .animation(.linear(duration: 0.3), value: progress)
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 4)
        }
        .animation(.easeInOut(duration: 0.3), value: timerColor)
        .onChange(of: timeRemaining) { _, newValue in
            updatePulseAnimation(for: newValue)
        }
        .onAppear {
            updatePulseAnimation(for: timeRemaining)
        }
    }

    // MARK: - Pulse Animation

    /// Updates the pulse animation based on the current time remaining
    private func updatePulseAnimation(for time: Int) {
        if time <= criticalThreshold && time > 0 {
            // Critical: faster pulse
            startPulse(duration: 0.35)
        } else if time <= warningThreshold && time > 0 {
            // Warning: slower pulse
            startPulse(duration: 0.6)
        } else {
            // Normal: no pulse
            stopPulse()
        }
    }

    /// Starts a repeating pulse animation at the given speed
    private func startPulse(duration: Double) {
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.08
        }
    }

    /// Stops the pulse and resets scale
    private func stopPulse() {
        withAnimation(.easeInOut(duration: 0.2)) {
            pulseScale = 1.0
        }
    }
}

// MARK: - Previews

#Preview("Normal") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TimerDisplay(timeRemaining: 45, totalTime: 60)
            .padding()
    }
}

#Preview("Warning (10s)") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TimerDisplay(timeRemaining: 8, totalTime: 60)
            .padding()
    }
}

#Preview("Critical (5s)") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TimerDisplay(timeRemaining: 3, totalTime: 60)
            .padding()
    }
}

#Preview("Timeout") {
    ZStack {
        Color.mdBackground.ignoresSafeArea()
        TimerDisplay(timeRemaining: 0, totalTime: 60)
            .padding()
    }
}
