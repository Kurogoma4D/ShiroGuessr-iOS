//
//  TutorialManager.swift
//  ShiroGuessr
//
//  Manages tutorial state for first-time users
//

import Foundation
import Combine

/// Manager for tutorial state
@MainActor
final class TutorialManager: ObservableObject {
    static let shared = TutorialManager()

    @Published var shouldShowTutorial: Bool = false

    private let userDefaults = UserDefaults.standard
    private let tutorialShownKey = "hasShownTutorial"

    private init() {
        checkTutorialStatus()
    }

    /// Check if tutorial should be shown
    func checkTutorialStatus() {
        shouldShowTutorial = !userDefaults.bool(forKey: tutorialShownKey)
    }

    /// Mark tutorial as shown
    func markTutorialAsShown() {
        userDefaults.set(true, forKey: tutorialShownKey)
        shouldShowTutorial = false
    }

    /// Reset tutorial flag (for testing)
    func resetTutorial() {
        userDefaults.removeObject(forKey: tutorialShownKey)
        checkTutorialStatus()
    }
}
