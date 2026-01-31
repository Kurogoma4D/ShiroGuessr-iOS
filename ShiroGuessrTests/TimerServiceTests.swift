import XCTest
@testable import ShiroGuessr

@MainActor
final class TimerServiceTests: XCTestCase {
    var sut: TimerService!

    override func setUp() {
        super.setUp()
        sut = TimerService()
    }

    override func tearDown() {
        sut.stopTimer()
        sut = nil
        super.tearDown()
    }

    // MARK: - startTimer Tests

    func testStartTimer_shouldSetInitialTimeRemaining() {
        sut.startTimer(seconds: 60)

        XCTAssertEqual(sut.timeRemaining, 60)
    }

    func testStartTimer_shouldDecrementTimeRemaining() async {
        let expectation = expectation(description: "Timer should tick")
        expectation.expectedFulfillmentCount = 1

        sut.startTimer(seconds: 5)

        // Wait for at least one tick
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        if sut.timeRemaining < 5 {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertLessThan(sut.timeRemaining, 5)
    }

    func testStartTimer_shouldCallOnTimeoutWhenReachingZero() async {
        let expectation = expectation(description: "Timeout callback should be called")

        sut.startTimer(seconds: 2) {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 3.0)
        XCTAssertEqual(sut.timeRemaining, 0)
    }

    // MARK: - stopTimer Tests

    func testStopTimer_shouldStopDecrementing() async {
        sut.startTimer(seconds: 10)

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        let timeAfterStart = sut.timeRemaining

        sut.stopTimer()

        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        let timeAfterStop = sut.timeRemaining

        XCTAssertEqual(timeAfterStart, timeAfterStop, "Time should not change after stopping")
    }

    // MARK: - resetTimer Tests

    func testResetTimer_shouldSetTimeToZero() {
        sut.startTimer(seconds: 60)
        sut.resetTimer()

        XCTAssertEqual(sut.timeRemaining, 0)
    }

    func testResetTimer_shouldStopTimer() async {
        sut.startTimer(seconds: 10)
        sut.resetTimer()

        let timeBefore = sut.timeRemaining

        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        let timeAfter = sut.timeRemaining

        XCTAssertEqual(timeBefore, timeAfter, "Time should not change after reset")
    }

    // MARK: - Multiple Starts Tests

    func testStartTimer_calledMultipleTimes_shouldRestartTimer() {
        sut.startTimer(seconds: 10)
        XCTAssertEqual(sut.timeRemaining, 10)

        sut.startTimer(seconds: 20)
        XCTAssertEqual(sut.timeRemaining, 20)
    }
}
