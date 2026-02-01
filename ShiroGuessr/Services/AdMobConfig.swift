import Foundation

/// Environment for AdMob configuration
enum AdMobEnvironment {
    case dev
    case prod

    static var current: AdMobEnvironment {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }
}

/// AdMob configuration manager
struct AdMobConfig {
    /// AdMob App ID
    static let appID: String = {
        switch AdMobEnvironment.current {
        case .dev:
            // Development: Use test App ID (safe to commit)
            return loadConfig(from: "AdMobConfig-Dev")["AppID"] ?? ""
        case .prod:
            // Production: Load from secure configuration file
            guard let appID = loadConfig(from: "AdMobConfig-Prod")["AppID"], !appID.isEmpty else {
                fatalError("""
                    Production AdMob configuration not found.
                    Please create 'AdMobConfig-Prod.plist' from 'AdMobConfig-Prod.plist.example'
                    and add your production AdMob App ID.
                    """)
            }
            return appID
        }
    }()

    /// Interstitial Ad Unit ID
    static let interstitialAdUnitID: String = {
        switch AdMobEnvironment.current {
        case .dev:
            // Development: Use test Interstitial Ad Unit ID (safe to commit)
            return loadConfig(from: "AdMobConfig-Dev")["InterstitialAdUnitID"] ?? ""
        case .prod:
            // Production: Load from secure configuration file
            guard let adUnitID = loadConfig(from: "AdMobConfig-Prod")["InterstitialAdUnitID"], !adUnitID.isEmpty else {
                fatalError("""
                    Production AdMob configuration not found.
                    Please create 'AdMobConfig-Prod.plist' from 'AdMobConfig-Prod.plist.example'
                    and add your production Interstitial Ad Unit ID.
                    """)
            }
            return adUnitID
        }
    }()

    /// Load configuration from plist file
    private static func loadConfig(from fileName: String) -> [String: String] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            if AdMobEnvironment.current == .prod {
                fatalError("""
                    Failed to load \(fileName).plist
                    Please create 'AdMobConfig-Prod.plist' from 'AdMobConfig-Prod.plist.example'
                    """)
            }
            return [:]
        }
        return dict
    }
}
