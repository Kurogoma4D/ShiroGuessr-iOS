import Foundation

/// A color in the palette with its RGB values
struct PaletteColor: Codable, Equatable {
    let color: RGBColor
}

/// A single round in the game
struct GameRound: Codable, Equatable {
    /// The round number (1-based)
    let roundNumber: Int
    /// The target color to guess
    let targetColor: RGBColor
    /// The color selected by the player
    let selectedColor: RGBColor?
    /// Manhattan distance between target and selected color
    let distance: Int?
    /// Score for this round (0-1000)
    let score: Int?
    /// Available colors in the palette for this round
    let paletteColors: [PaletteColor]
    /// Pin placed on the map (for map mode)
    let pin: Pin?
    /// Target pin location on the map (for map mode)
    let targetPin: Pin?
    /// Time remaining when the guess was made (for map mode)
    let timeRemaining: Int?
}
