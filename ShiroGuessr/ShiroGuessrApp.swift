//
//  ShiroGuessrApp.swift
//  ShiroGuessr
//
//  Created by Kurogoma4D on 2026/01/31.
//

import SwiftUI
import Combine
import GoogleMobileAds
import AppTrackingTransparency

enum GameMode {
    case classicMode
    case mapMode
}

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var currentMode: GameMode = .mapMode
    @StateObject private var tutorialManager = TutorialManager.shared
    @State private var mapGameViewModel: MapGameViewModel?
    @State private var hasRequestedATT = false

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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && !hasRequestedATT {
                hasRequestedATT = true
                Task {
                    await requestTrackingAuthorizationAndInitializeAds()
                }
            }
        }
        .sheet(isPresented: $tutorialManager.shouldShowTutorial) {
            TutorialBottomSheet(isPresented: $tutorialManager.shouldShowTutorial)
                .presentationDetents([.large])
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

    private func requestTrackingAuthorizationAndInitializeAds() async {
        guard !ShiroGuessrApp.isRunningTests else { return }

        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .notDetermined {
            _ = await ATTrackingManager.requestTrackingAuthorization()
        }

        // Initialize ads after ATT authorization is resolved (regardless of result)
        await MobileAds.shared.start()
        InterstitialAdManager.shared.loadAd()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let pauseGameTimer = Notification.Name("pauseGameTimer")
    static let resumeGameTimer = Notification.Name("resumeGameTimer")
}

@main
struct ShiroGuessrApp: App {
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
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
