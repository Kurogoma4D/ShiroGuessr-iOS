import Foundation
import Combine

/// Service for managing game timers
@MainActor
@Observable
final class TimerService {
    // MARK: - Published Properties

    /// Remaining time in seconds
    private(set) var timeRemaining: Int = 0

    // MARK: - Private Properties

    /// Callback to execute when timer reaches zero
    private var onTimeout: (() -> Void)?

    /// Timer publisher
    private var timerCancellable: AnyCancellable?

    /// Whether the timer is currently running
    private var isRunning = false

    // MARK: - Initialization

    nonisolated init() {}

    // MARK: - Public Methods

    /// Starts the timer with the specified duration
    /// - Parameters:
    ///   - seconds: Duration in seconds
    ///   - onTimeout: Optional callback to execute when timer reaches zero
    func startTimer(seconds: Int, onTimeout: (() -> Void)? = nil) {
        stopTimer()

        timeRemaining = seconds
        self.onTimeout = onTimeout
        isRunning = true

        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    self.tick()
                }
            }
    }

    /// Stops the timer
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
    }

    /// Resets the timer to zero and stops it
    func resetTimer() {
        stopTimer()
        timeRemaining = 0
        onTimeout = nil
    }

    // MARK: - Private Methods

    /// Decrements the timer and handles timeout
    private func tick() {
        guard isRunning, timeRemaining > 0 else { return }

        timeRemaining -= 1

        if timeRemaining == 0 {
            stopTimer()
            onTimeout?()
        }
    }
}
