import Foundation

/// Overall game state
struct GameState: Codable, Equatable {
    /// All rounds in the game
    let rounds: [GameRound]
    /// Current round index (0-based)
    let currentRoundIndex: Int
    /// Whether the game has been completed
    let isCompleted: Bool
    /// Total score across all rounds
    let totalScore: Int
    /// Time limit per round in seconds (for map mode)
    let timeLimit: Int?
}
