import SwiftUI
import UIKit

/// Service for sharing game results
class ShareService {
    /// Generate shareable text for game results
    /// - Parameter gameState: The completed game state
    /// - Returns: Formatted text ready for sharing
    static func generateShareText(gameState: GameState) -> String {
        guard gameState.isCompleted else {
            return ""
        }

        var text = "白Guessr 🎨\n"
        text += "\(L10n.Share.score) \(formatScore(gameState.totalScore)) / 5,000\n\n"

        // Add each round's result
        for round in gameState.rounds {
            let stars = generateStarRating(for: round)
            let distance = round.distance ?? 0
            text += "\(L10n.Share.round(round.roundNumber)) \(stars) (\(L10n.Share.distance) \(distance))\n"
        }

        text += "\nhttps://shiro-guessr.pages.dev/app\n\n"
        text += "#白Guessr"

        return text
    }

    /// Format score with comma separators
    /// - Parameter score: The score to format
    /// - Returns: Formatted score string (e.g., "4,523")
    private static func formatScore(_ score: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: score)) ?? "\(score)"
    }

    /// Generate star rating based on round performance
    /// - Parameter round: The game round
    /// - Returns: Star rating string (e.g., "⭐⭐⭐⭐⭐")
    private static func generateStarRating(for round: GameRound) -> String {
        guard let distance = round.distance else {
            return "⭐"
        }

        // 5 stars: distance 0-5
        // 4 stars: distance 6-10
        // 3 stars: distance 11-20
        // 2 stars: distance 21-40
        // 1 star: distance > 40
        let starCount: Int
        switch distance {
        case 0...5:
            starCount = 5
        case 6...10:
            starCount = 4
        case 11...20:
            starCount = 3
        case 21...40:
            starCount = 2
        default:
            starCount = 1
        }

        return String(repeating: "⭐", count: starCount)
    }

    /// Copy text to clipboard
    /// - Parameter text: Text to copy
    static func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

/// SwiftUI wrapper for ShareLink with custom share text
struct ShareButton: View {
    let gameState: GameState
    let label: String
    let icon: String
    let useOutlinedStyle: Bool

    init(gameState: GameState, label: String? = nil, icon: String = "square.and.arrow.up", useOutlinedStyle: Bool = false) {
        self.gameState = gameState
        self.label = label ?? L10n.Result.share
        self.icon = icon
        self.useOutlinedStyle = useOutlinedStyle
    }

    var body: some View {
        ShareLink(
            item: ShareService.generateShareText(gameState: gameState)
        ) {
            HStack {
                Image(systemName: icon)
                    .font(.mdLabelLarge)
                Text(label)
                    .font(.mdLabelLarge)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(useOutlinedStyle ? Color.mdPrimary : Color.mdOnSecondaryContainer)
            .background(
                useOutlinedStyle
                    ? Color.clear
                    : Color.mdSecondaryContainer
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                useOutlinedStyle
                    ? RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color.mdSecondary, lineWidth: 1.5)
                    : nil
            )
        }
    }
}

#Preview("Share Text") {
    let gameState = GameState(
        rounds: [
            GameRound(
                roundNumber: 1,
                targetColor: RGBColor(r: 250, g: 248, b: 252),
                selectedColor: RGBColor(r: 248, g: 250, b: 250),
                distance: 2,
                score: 940,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ),
            GameRound(
                roundNumber: 2,
                targetColor: RGBColor(r: 255, g: 255, b: 255),
                selectedColor: RGBColor(r: 247, g: 255, b: 255),
                distance: 8,
                score: 760,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ),
            GameRound(
                roundNumber: 3,
                targetColor: RGBColor(r: 245, g: 250, b: 248),
                selectedColor: RGBColor(r: 245, g: 250, b: 248),
                distance: 0,
                score: 1000,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ),
            GameRound(
                roundNumber: 4,
                targetColor: RGBColor(r: 252, g: 245, b: 255),
                selectedColor: RGBColor(r: 237, g: 245, b: 255),
                distance: 15,
                score: 550,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ),
            GameRound(
                roundNumber: 5,
                targetColor: RGBColor(r: 248, g: 252, b: 245),
                selectedColor: RGBColor(r: 248, g: 247, b: 240),
                distance: 5,
                score: 850,
                paletteColors: [],
                pin: nil,
                targetPin: nil,
                timeRemaining: nil
            ),
        ],
        currentRoundIndex: 5,
        isCompleted: true,
        totalScore: 4100,
        timeLimit: nil
    )

    VStack(spacing: 20) {
        Text(ShareService.generateShareText(gameState: gameState))
            .font(.system(.body, design: .monospaced))
            .padding()

        ShareButton(gameState: gameState)
            .padding()
    }
}
