//
//  LocalizationService.swift
//  ShiroGuessr
//
//  Service for type-safe localization
//

import Foundation

/// Type-safe localization keys
enum L10n {
    // MARK: - Home Screen
    enum Home {
        static let tagline = NSLocalizedString("home.tagline", comment: "Home screen tagline")
        static let classicMode = NSLocalizedString("home.classicMode", comment: "Classic mode button")
        static let classicModeSubtitle = NSLocalizedString("home.classicModeSubtitle", comment: "Classic mode description")
        static let mapMode = NSLocalizedString("home.mapMode", comment: "Map mode button")
        static let mapModeSubtitle = NSLocalizedString("home.mapModeSubtitle", comment: "Map mode description")
    }

    // MARK: - Game Screen
    enum Game {
        static let startGame = NSLocalizedString("game.startGame", comment: "Start game button")
static let loading = NSLocalizedString("game.loading", comment: "Loading text")
    }

    // MARK: - Game Controls
    enum Controls {
        static let submitAnswer = NSLocalizedString("controls.submitAnswer", comment: "Submit answer button")
        static let nextRound = NSLocalizedString("controls.nextRound", comment: "Next round button")
    }

    // MARK: - Round Result Dialog
    enum RoundResult {
        static func title(_ round: Int) -> String {
            String(format: NSLocalizedString("roundResult.title", comment: "Round result title"), round)
        }
        static let target = NSLocalizedString("roundResult.target", comment: "Target label")
        static let yourGuess = NSLocalizedString("roundResult.yourGuess", comment: "Your guess label")
        static let distance = NSLocalizedString("roundResult.distance", comment: "Distance label")
        static let score = NSLocalizedString("roundResult.score", comment: "Score label")
        static let `continue` = NSLocalizedString("roundResult.continue", comment: "Continue button")
    }

    // MARK: - Result Screen
    enum Result {
        static let gameComplete = NSLocalizedString("result.gameComplete", comment: "Game complete title")
        static let totalScore = NSLocalizedString("result.totalScore", comment: "Total score label")
        static let outOf5000 = NSLocalizedString("result.outOf5000", comment: "Out of 5000 text")
        static let roundResults = NSLocalizedString("result.roundResults", comment: "Round results section title")
        static let playAgain = NSLocalizedString("result.playAgain", comment: "Play again button")
        static let share = NSLocalizedString("result.share", comment: "Share button")
        static let copyToClipboard = NSLocalizedString("result.copyToClipboard", comment: "Copy to clipboard button")
        static let home = NSLocalizedString("result.home", comment: "Home button")
    }

    // MARK: - Share Service
    enum Share {
        static let score = NSLocalizedString("share.score", comment: "Score label for sharing")
        static func round(_ round: Int) -> String {
            String(format: NSLocalizedString("share.round", comment: "Round label for sharing"), round)
        }
        static let distance = NSLocalizedString("share.distance", comment: "Distance label for sharing")
    }

    // MARK: - Accessibility
    enum Accessibility {
        static let tapToStart = NSLocalizedString("accessibility.tapToStart", comment: "Hint for mode selection")
        static func currentScore(_ score: Int) -> String {
            String(format: NSLocalizedString("accessibility.currentScore", comment: "Current score for VoiceOver"), score)
        }
        static func roundProgress(_ current: Int, _ total: Int) -> String {
            String(format: NSLocalizedString("accessibility.roundProgress", comment: "Round progress for VoiceOver"), current, total)
        }
        static func targetColor(_ css: String) -> String {
            String(format: NSLocalizedString("accessibility.targetColor", comment: "Target color for VoiceOver"), css)
        }
        static let colorPalette = NSLocalizedString("accessibility.colorPalette", comment: "Color palette label")
        static func colorCell(_ index: Int, _ total: Int, _ css: String) -> String {
            String(format: NSLocalizedString("accessibility.colorCell", comment: "Color cell for VoiceOver"), index, total, css)
        }
        static let tapToSelect = NSLocalizedString("accessibility.tapToSelect", comment: "Hint to tap color")
        static func timeRemaining(_ seconds: Int) -> String {
            String(format: NSLocalizedString("accessibility.timeRemaining", comment: "Time remaining for VoiceOver"), seconds)
        }
        static let timerWarning = NSLocalizedString("accessibility.timerWarning", comment: "Timer warning state")
        static let timerCritical = NSLocalizedString("accessibility.timerCritical", comment: "Timer critical state")
        static let gradientMap = NSLocalizedString("accessibility.gradientMap", comment: "Gradient map label")
        static let tapToPlacePin = NSLocalizedString("accessibility.tapToPlacePin", comment: "Hint to place pin")
        static func starRating(_ stars: Int) -> String {
            String(format: NSLocalizedString("accessibility.starRating", comment: "Star rating for VoiceOver"), stars)
        }
        static func roundScore(_ score: Int, _ max: Int) -> String {
            String(format: NSLocalizedString("accessibility.roundScore", comment: "Round score for VoiceOver"), score, max)
        }
        static func colorDistance(_ distance: Int) -> String {
            String(format: NSLocalizedString("accessibility.colorDistance", comment: "Color distance for VoiceOver"), distance)
        }
        static func yourGuessColor(_ css: String) -> String {
            String(format: NSLocalizedString("accessibility.yourGuessColor", comment: "Your guess color for VoiceOver"), css)
        }
        static let noGuess = NSLocalizedString("accessibility.noGuess", comment: "No guess made")
        static func totalScore(_ score: Int, _ max: Int) -> String {
            String(format: NSLocalizedString("accessibility.totalScore", comment: "Total score for VoiceOver"), score, max)
        }
        static func roundResult(_ round: Int, _ score: Int, _ stars: Int) -> String {
            String(format: NSLocalizedString("accessibility.roundResult", comment: "Round result summary for VoiceOver"), round, score, stars)
        }
        static let submitHint = NSLocalizedString("accessibility.submitHint", comment: "Submit button hint")
        static func tutorialPage(_ current: Int, _ total: Int) -> String {
            String(format: NSLocalizedString("accessibility.tutorialPage", comment: "Tutorial page indicator"), current, total)
        }
    }

    // MARK: - Tutorial
    enum Tutorial {
        static let welcome = NSLocalizedString("tutorial.welcome", comment: "Tutorial welcome title")
        static let welcomeDescription = NSLocalizedString("tutorial.welcomeDescription", comment: "Tutorial welcome description")
        static let howToPlay = NSLocalizedString("tutorial.howToPlay", comment: "How to play title")
        static let howToPlayDescription = NSLocalizedString("tutorial.howToPlayDescription", comment: "How to play description")
        static let gameModes = NSLocalizedString("tutorial.gameModes", comment: "Game modes title")
        static let gameModesDescription = NSLocalizedString("tutorial.gameModesDescription", comment: "Game modes description")
        static let next = NSLocalizedString("tutorial.next", comment: "Next button")
        static let getStarted = NSLocalizedString("tutorial.getStarted", comment: "Get started button")
    }
}
