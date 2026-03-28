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
    @State private var currentScreen: CurrentScreen = .home
    @StateObject private var tutorialManager = TutorialManager.shared
    @State private var hasRequestedATT = false

    var body: some View {
        Group {
            switch currentScreen {
            case .home:
                HomeScreen()
                    .transition(.opacity)
            case .classic:
                ClassicGameScreen(onBackToHome: navigateHome)
                    .transition(.opacity)
            case .map:
                MapGameScreen(onBackToHome: navigateHome)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
        .onReceive(NotificationCenter.default.publisher(for: .navigateToGame)) { notification in
            if let mode = notification.object as? GameMode {
                withAnimation(.easeInOut(duration: 0.3)) {
                    switch mode {
                    case .classicMode:
                        currentScreen = .classic
                    case .mapMode:
                        currentScreen = .map
                    }
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
            if isShowing {
                NotificationCenter.default.post(name: .pauseGameTimer, object: nil)
            } else {
                NotificationCenter.default.post(name: .resumeGameTimer, object: nil)
            }
        }
    }

    private func navigateHome() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .home
        }
    }

    private func requestTrackingAuthorizationAndInitializeAds() async {
        guard !ShiroGuessrApp.isRunningTests else { return }

        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .notDetermined {
            _ = await ATTrackingManager.requestTrackingAuthorization()
        }

        await MobileAds.shared.start()
        InterstitialAdManager.shared.loadAd()
    }
}

// MARK: - Screen State

enum CurrentScreen: Equatable {
    case home
    case classic
    case map
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
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
        }
    }

    /// Handle Universal Links from shiro-guessr.pages.dev/app
    /// - Parameter url: The incoming URL
    private func handleUniversalLink(_ url: URL) {
        print("Received Universal Link: \(url)")

        if url.path == "/app" || url.path.contains("/app") {
            print("App opened from share link")
        }
    }
}
