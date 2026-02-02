//
//  ShiroGuessrApp.swift
//  ShiroGuessr
//
//  Created by Kurogoma4D on 2026/01/31.
//

import SwiftUI
import Combine
#if !TESTING
import GoogleMobileAds
#endif

enum GameMode {
    case classicMode
    case mapMode
}

struct RootView: View {
    @State private var currentMode: GameMode = .mapMode
    @StateObject private var tutorialManager = TutorialManager.shared
    @State private var mapGameViewModel: MapGameViewModel?

    var body: some View {
        Group {
            switch currentMode {
            case .classicMode:
                ClassicGameScreen(onModeToggle: toggleMode)
            case .mapMode:
                MapGameScreen(onModeToggle: toggleMode)
                    .onAppear {
                        // Store reference to access timer controls (this is a workaround)
                        // In production, consider using environment object or dependency injection
                    }
            }
        }
        .sheet(isPresented: $tutorialManager.shouldShowTutorial) {
            TutorialBottomSheet(isPresented: $tutorialManager.shouldShowTutorial)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        .onChange(of: tutorialManager.shouldShowTutorial) { _, isShowing in
            // Pause/resume timer based on tutorial visibility
            // Note: This is a simplified approach. For better control,
            // consider using environment object to access the view model
            if isShowing {
                // Timer will be paused when tutorial appears
                NotificationCenter.default.post(name: .pauseGameTimer, object: nil)
            } else {
                // Resume timer when tutorial is dismissed
                NotificationCenter.default.post(name: .resumeGameTimer, object: nil)
            }
        }
    }

    private func toggleMode() {
        currentMode = currentMode == .mapMode ? .classicMode : .mapMode
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let pauseGameTimer = Notification.Name("pauseGameTimer")
    static let resumeGameTimer = Notification.Name("resumeGameTimer")
}

@main
struct ShiroGuessrApp: App {
    init() {
        #if !TESTING
        // Initialize Google Mobile Ads SDK
        MobileAds.shared.start()

        // Preload the first interstitial ad
        Task { @MainActor in
            InterstitialAdManager.shared.loadAd()
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
        }
    }

    /// Handle Universal Links from shiro-guessr.pages.dev/ios
    /// - Parameter url: The incoming URL
    private func handleUniversalLink(_ url: URL) {
        // For now, just log the URL
        // In production, this could navigate to a specific screen or show a welcome message
        print("Received Universal Link: \(url)")

        // Example: Check if it's the /ios path
        if url.path == "/ios" || url.path.contains("/ios") {
            // App was opened from the share link
            // Could show a welcome message or tutorial
            print("App opened from share link")
        }
    }
}
