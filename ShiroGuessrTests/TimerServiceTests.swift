import Testing
@testable import ShiroGuessr

@Suite("TimerService Tests")
@MainActor
struct TimerServiceTests {

    // MARK: - startTimer Tests

    @Test("startTimer should set initial time remaining")
    func startTimer_shouldSetInitialTimeRemaining() {
        let sut = TimerService()
        sut.startTimer(seconds: 60)

        #expect(sut.timeRemaining == 60)

        sut.stopTimer()
    }

    @Test("startTimer should decrement time remaining")
    func startTimer_shouldDecrementTimeRemaining() async {
        let sut = TimerService()
        sut.startTimer(seconds: 5)

        // Wait for at least one tick
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        #expect(sut.timeRemaining < 5)

        sut.stopTimer()
    }

    @Test("startTimer should call onTimeout when reaching zero")
    func startTimer_shouldCallOnTimeoutWhenReachingZero() async {
        let sut = TimerService()
        var timeoutCalled = false

        sut.startTimer(seconds: 2) {
            timeoutCalled = true
        }

        // Wait for timeout with some buffer
        try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds

        #expect(timeoutCalled)
        #expect(sut.timeRemaining == 0)

        sut.stopTimer()
    }

    // MARK: - stopTimer Tests

    @Test("stopTimer should stop decrementing")
    func stopTimer_shouldStopDecrementing() async {
        let sut = TimerService()
        sut.startTimer(seconds: 10)

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        let timeAfterStart = sut.timeRemaining

        sut.stopTimer()

        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        let timeAfterStop = sut.timeRemaining

        #expect(timeAfterStart == timeAfterStop)
    }

    // MARK: - resetTimer Tests

    @Test("resetTimer should set time to zero")
    func resetTimer_shouldSetTimeToZero() {
        let sut = TimerService()
        sut.startTimer(seconds: 60)
        sut.resetTimer()

        #expect(sut.timeRemaining == 0)
    }

    @Test("resetTimer should stop timer")
    func resetTimer_shouldStopTimer() async {
        let sut = TimerService()
        sut.startTimer(seconds: 10)
        sut.resetTimer()

        let timeBefore = sut.timeRemaining

        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        let timeAfter = sut.timeRemaining

        #expect(timeBefore == timeAfter)
    }

    // MARK: - Multiple Starts Tests

    @Test("startTimer called multiple times should restart timer")
    func startTimer_calledMultipleTimes_shouldRestartTimer() {
        let sut = TimerService()
        sut.startTimer(seconds: 10)
        #expect(sut.timeRemaining == 10)

        sut.startTimer(seconds: 20)
        #expect(sut.timeRemaining == 20)

        sut.stopTimer()
    }
}
