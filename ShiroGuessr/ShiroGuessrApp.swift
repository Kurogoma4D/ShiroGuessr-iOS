//
//  ShiroGuessrApp.swift
//  ShiroGuessr
//
//  Created by Kurogoma4D on 2026/01/31.
//

import SwiftUI
import Combine

enum GameMode {
    case classicMode
    case mapMode
}

struct RootView: View {
    @State private var currentMode: GameMode = .mapMode

    var body: some View {
        Group {
            switch currentMode {
            case .classicMode:
                ClassicGameScreen(onModeToggle: toggleMode)
            case .mapMode:
                MapGameScreen(onModeToggle: toggleMode)
            }
        }
    }

    private func toggleMode() {
        currentMode = currentMode == .mapMode ? .classicMode : .mapMode
    }
}

@main
struct ShiroGuessrApp: App {
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
