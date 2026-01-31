import Foundation

/// Service for calculating game scores
final class ScoreService {
    /// Maximum possible score for a single round
    private let maxRoundScore = 1000

    /// Maximum possible Manhattan distance for white colors (245-255 range)
    /// Distance = |255-245| + |255-245| + |255-245| = 30
    private let maxDistance = 30

    /// Calculates the score for a single round based on Manhattan distance
    /// Formula: 1000 × (1 - distance / 30)
    /// - Distance 0 (perfect match) = 1000 points
    /// - Distance 30 (maximum) = 0 points
    /// - Score decreases linearly with distance
    ///
    /// - Parameter distance: Manhattan distance between selected and target color
    /// - Returns: Score for the round (0-1000)
    func calculateRoundScore(distance: Int) -> Int {
        // Clamp distance to valid range [0, 30]
        let clampedDistance = max(0, min(distance, maxDistance))

        // Calculate score: 1000 × (1 - distance / 30)
        let score = Double(maxRoundScore) * (1.0 - Double(clampedDistance) / Double(maxDistance))

        // Round to nearest integer for cleaner scores
        return Int(round(score))
    }

    /// Calculates the total score across all completed rounds
    /// - Parameter rounds: Array of game rounds
    /// - Returns: Total score (sum of all round scores)
    func calculateTotalScore(rounds: [GameRound]) -> Int {
        rounds.reduce(0) { total, round in
            // Only count rounds that have been completed (score is not nil)
            total + (round.score ?? 0)
        }
    }
}
