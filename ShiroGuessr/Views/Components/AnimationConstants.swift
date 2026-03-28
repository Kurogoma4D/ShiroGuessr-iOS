import SwiftUI

/// Centralized animation constants following the Shiro Gallery design guideline (Section 6).
///
/// Three animation categories:
/// - **Spring**: In-game interactions (target pin pop-in, score bounce).
///   `response: 0.4, dampingFraction: 0.7`
/// - **Tween/Ease**: Continuous transitions like color changes and fades.
///   `300-500ms, EaseInOut`
/// - **Ease-Out**: Quick responsive feedback like pin placement.
///   `150ms, EaseOut`
enum AnimationConstants {

    // MARK: - Spring Animation (In-game interactions)

    /// Standard spring animation for in-game interactions.
    /// Used for: target pin pop-in, score bounce, selection ring, button state changes.
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.7)

    /// Lighter spring for subtle feedback (e.g., button press scale).
    static let springLight = Animation.spring(response: 0.3, dampingFraction: 0.7)

    // MARK: - Tween / Ease (Continuous transitions)

    /// Standard tween for color changes, fades, and continuous transitions (300ms).
    static let tweenShort = Animation.easeInOut(duration: 0.3)

    /// Medium tween for transitions (400ms).
    static let tweenMedium = Animation.easeInOut(duration: 0.4)

    /// Longer tween for more prominent transitions (500ms).
    static let tweenLong = Animation.easeInOut(duration: 0.5)

    // MARK: - Ease-Out (Quick responsive feedback)

    /// Quick ease-out for instant-feeling responses (150ms).
    /// Used for: pin placement drop, palette cell press, selection feedback.
    static let quickResponse = Animation.easeOut(duration: 0.15)

    // MARK: - Stagger Intervals

    /// Stagger interval for sequential item reveals (100ms).
    static let staggerInterval: Double = 0.1

    // MARK: - Brief Freeze

    /// Duration for the brief freeze after guess submission (100ms).
    static let submitFreezeMilliseconds: UInt64 = 100
}
