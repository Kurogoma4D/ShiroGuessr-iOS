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
        text += "スコア: \(formatScore(gameState.totalScore)) / 5,000\n\n"

        // Add each round's result
        for round in gameState.rounds {
            let stars = generateStarRating(for: round)
            let distance = round.distance ?? 0
            text += "Round \(round.roundNumber): \(stars) (距離: \(distance))\n"
        }

        text += "\nhttps://shiro-guessr.pages.dev/ios\n\n"
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

    /// Share text using system share sheet
    /// - Parameters:
    ///   - text: Text to share
    ///   - sourceView: Optional source view for iPad popover
    static func shareText(_ text: String, from sourceView: UIView? = nil) {
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )

        // Configure for iPad
        if let sourceView = sourceView,
           let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }

        presentActivityViewController(activityVC)
    }

    /// Copy text to clipboard
    /// - Parameter text: Text to copy
    static func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }

    /// Share a SwiftUI view as an image
    /// - Parameters:
    ///   - view: The view to render
    ///   - sourceView: Optional source view for iPad popover
    @MainActor
    static func shareViewAsImage<Content: View>(_ view: Content, from sourceView: UIView? = nil) {
        let renderer = ImageRenderer(content: view)

        // Set scale for high quality
        renderer.scale = UIScreen.main.scale

        guard let image = renderer.uiImage else {
            return
        }

        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        // Configure for iPad
        if let sourceView = sourceView,
           let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }

        presentActivityViewController(activityVC)
    }

    /// Present activity view controller from the top-most view controller
    /// - Parameter activityVC: The activity view controller to present
    private static func presentActivityViewController(_ activityVC: UIActivityViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }

        // Find the top-most view controller
        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }

        topVC.present(activityVC, animated: true)
    }
}

/// SwiftUI wrapper for ShareLink with custom share text
struct ShareButton: View {
    let gameState: GameState
    let label: String
    let icon: String

    init(gameState: GameState, label: String = "Share Results", icon: String = "square.and.arrow.up") {
        self.gameState = gameState
        self.label = label
        self.icon = icon
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
            .foregroundStyle(Color.mdOnSecondaryContainer)
            .background(Color.mdSecondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 24))
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
