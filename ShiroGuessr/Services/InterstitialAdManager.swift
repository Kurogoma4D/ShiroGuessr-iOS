import Foundation
import GoogleMobileAds
import SwiftUI
import Combine

/// Manager for handling interstitial ads
@MainActor
class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    /// Shared singleton instance
    static let shared = InterstitialAdManager()

    /// The currently loaded interstitial ad
    private var interstitialAd: InterstitialAd?

    /// Whether an ad is currently loaded and ready to show
    @Published var isAdLoaded = false

    /// Whether an ad is currently being shown
    @Published var isShowingAd = false

    /// Callback to execute after ad is dismissed
    private var onAdDismissed: (() -> Void)?

    private override init() {
        super.init()
    }

    /// Load an interstitial ad
    func loadAd() {
        let adUnitID = AdMobConfig.interstitialAdUnitID

        InterstitialAd.load(
            with: adUnitID,
            request: Request()
        ) { [weak self] ad, error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                self.isAdLoaded = false
                return
            }

            print("Interstitial ad loaded successfully")
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            self.isAdLoaded = true
        }
    }

    /// Show the interstitial ad
    /// - Parameters:
    ///   - onDismissed: Callback to execute when ad is dismissed
    func showAd(onDismissed: @escaping () -> Void) {
        guard let interstitialAd = interstitialAd else {
            print("Interstitial ad not loaded, executing callback immediately")
            onDismissed()
            return
        }

        // Find the root view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Failed to find root view controller")
            onDismissed()
            return
        }

        self.onAdDismissed = onDismissed
        isShowingAd = true

        // Present the ad
        interstitialAd.present(from: rootViewController)
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad recorded impression")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad recorded click")
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial ad failed to present: \(error.localizedDescription)")
        isShowingAd = false
        isAdLoaded = false

        // Execute callback even if ad failed to present
        onAdDismissed?()
        onAdDismissed = nil

        // Try to load a new ad for next time
        loadAd()
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad will present")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad dismissed")
        isShowingAd = false
        isAdLoaded = false

        // Execute the callback
        onAdDismissed?()
        onAdDismissed = nil

        // Load a new ad for next time
        loadAd()
    }
}
