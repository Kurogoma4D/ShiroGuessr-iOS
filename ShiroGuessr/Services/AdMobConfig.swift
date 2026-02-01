import Foundation

/// AdMob configuration manager
/// Configuration values are loaded from Info.plist, which uses xcconfig files for environment-specific values
struct AdMobConfig {
    /// Interstitial Ad Unit ID
    /// The value is set in Info.plist using $(ADMOB_INTERSTITIAL_AD_UNIT_ID) from xcconfig files
    static let interstitialAdUnitID: String = {
        guard let adUnitID = Bundle.main.object(forInfoDictionaryKey: "AdMobInterstitialAdUnitID") as? String,
              !adUnitID.isEmpty else {
            fatalError("""
                AdMob Interstitial Ad Unit ID not found in Info.plist.
                Please ensure:
                1. Info.plist contains AdMobInterstitialAdUnitID key with $(ADMOB_INTERSTITIAL_AD_UNIT_ID) value
                2. Dev.xcconfig or Prod.xcconfig is properly configured in project settings
                3. ADMOB_INTERSTITIAL_AD_UNIT_ID is defined in the active configuration's xcconfig file
                """)
        }
        return adUnitID
    }()
}
