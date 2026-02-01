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
        static let mapMode = NSLocalizedString("home.mapMode", comment: "Map mode button")
    }

    // MARK: - Game Screen
    enum Game {
        static let startGame = NSLocalizedString("game.startGame", comment: "Start game button")
        static let findThisColor = NSLocalizedString("game.findThisColor", comment: "Find this color label")
        static let findThisColorColon = NSLocalizedString("game.findThisColorColon", comment: "Find this color label with colon")
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
    }

    // MARK: - Share Service
    enum Share {
        static let score = NSLocalizedString("share.score", comment: "Score label for sharing")
        static func round(_ round: Int) -> String {
            String(format: NSLocalizedString("share.round", comment: "Round label for sharing"), round)
        }
        static let distance = NSLocalizedString("share.distance", comment: "Distance label for sharing")
    }
}
