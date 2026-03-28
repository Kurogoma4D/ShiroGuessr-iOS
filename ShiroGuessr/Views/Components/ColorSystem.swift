//
//  ColorSystem.swift
//  ShiroGuessr
//
//  "Shiro Gallery" Dark-Based Color System
//  Based on the Shiro Gallery design guideline.
//  Dark background maximizes contrast for subtle white color perception.
//

import SwiftUI

/// Shiro Gallery Color System for ShiroGuessr
extension Color {
    // MARK: - Surface & Background
    /// Main background — deep ink (#0D0D12)
    static let mdBackground = Color(red: 0.051, green: 0.051, blue: 0.071)
    /// Card / panel background (#1A1A22)
    static let mdSurface = Color(red: 0.102, green: 0.102, blue: 0.133)
    /// Secondary surface (#252530)
    static let mdSurfaceVariant = Color(red: 0.145, green: 0.145, blue: 0.188)

    // MARK: - Accent: Warm Gold
    /// Gold accent — CTA, selection, score (#C9A96E)
    static let mdPrimary = Color(red: 0.788, green: 0.663, blue: 0.431)
    /// Dark text on gold buttons (#0D0D12)
    static let mdOnPrimary = Color(red: 0.051, green: 0.051, blue: 0.071)
    /// Accent background (#2A2520)
    static let mdPrimaryContainer = Color(red: 0.165, green: 0.145, blue: 0.125)
    /// Gold accent on accent background (#C9A96E)
    static let mdOnPrimaryContainer = Color(red: 0.788, green: 0.663, blue: 0.431)

    // MARK: - Secondary (Muted Gold)
    /// Muted gold — secondary UI elements (#8B7A5E)
    static let mdSecondary = Color(red: 0.545, green: 0.478, blue: 0.369)
    /// Dark text on secondary (#0D0D12)
    static let mdOnSecondary = Color(red: 0.051, green: 0.051, blue: 0.071)
    /// Secondary container — subtle surface (#252530)
    static let mdSecondaryContainer = Color(red: 0.145, green: 0.145, blue: 0.188)
    /// Text on secondary container (#E8E6E3)
    static let mdOnSecondaryContainer = Color(red: 0.910, green: 0.902, blue: 0.890)

    // MARK: - Tertiary (reuse secondary gold for consistency)
    static let mdTertiary = mdSecondary
    static let mdOnTertiary = mdOnSecondary
    static let mdTertiaryContainer = mdSecondaryContainer
    static let mdOnTertiaryContainer = mdOnSecondaryContainer

    // MARK: - Error / Feedback
    /// Low score / error — muted red (#C87E7E)
    static let mdError = Color(red: 0.784, green: 0.494, blue: 0.494)
    static let mdOnError = Color(red: 0.051, green: 0.051, blue: 0.071)
    /// Error container — dark red (#2A2020)
    static let mdErrorContainer = Color(red: 0.165, green: 0.125, blue: 0.125)
    /// Error text on container (#C87E7E)
    static let mdOnErrorContainer = Color(red: 0.784, green: 0.494, blue: 0.494)

    // MARK: - On-Surface Text
    /// Muted text (#7E7A90) — adjusted from #5C5866 for WCAG AA compliance (4.5:1+ on deep bg)
    static let textMuted = Color(red: 0.494, green: 0.478, blue: 0.565)
    /// Main text — slightly warm off-white (#E8E6E3)
    static let mdOnBackground = Color(red: 0.910, green: 0.902, blue: 0.890)
    /// Main text on surfaces (#E8E6E3)
    static let mdOnSurface = Color(red: 0.910, green: 0.902, blue: 0.890)
    /// Secondary text (#9995A0)
    static let mdOnSurfaceVariant = Color(red: 0.600, green: 0.584, blue: 0.627)

    // MARK: - Outline Colors
    /// Border around color samples (#4A4A58) — adjusted from #3A3A45 for better visual distinction
    static let mdOutline = Color(red: 0.290, green: 0.290, blue: 0.345)
    /// Subtle separation border (#2A2A35)
    static let mdOutlineVariant = Color(red: 0.165, green: 0.165, blue: 0.208)

    // MARK: - Shadow & Scrim
    /// Drop shadow for color samples (rgba(0,0,0,0.4))
    static let mdShadow = Color.black.opacity(0.4)
    /// Scrim overlay
    static let mdScrim = Color.black.opacity(0.5)

    // MARK: - Feedback Colors (new semantic tokens)
    /// High score — muted green (#7EC88B)
    static let scoreHigh = Color(red: 0.494, green: 0.784, blue: 0.545)
    /// Mid score — unified with accent (#C9A96E)
    static let scoreMid = Color(red: 0.788, green: 0.663, blue: 0.431)
    /// Low score — muted red (#C87E7E)
    static let scoreLow = Color(red: 0.784, green: 0.494, blue: 0.494)
    /// Timer warning — orange (#D4956B)
    static let timerWarning = Color(red: 0.831, green: 0.584, blue: 0.420)
    /// Timer critical — red (#C87E7E)
    static let timerCritical = Color(red: 0.784, green: 0.494, blue: 0.494)

    // MARK: - Color Sample Display
    /// Border around color samples — alias for mdOutline (#3A3A45)
    static let sampleBorder = mdOutline
    /// Drop shadow for color samples — alias for mdShadow (rgba(0,0,0,0.4))
    static let sampleShadow = mdShadow
    /// Neutral-gray mid-value frame for color sample areas (#787880)
    static let sampleFrame = Color(red: 0.471, green: 0.471, blue: 0.502)
}

/// "Shiro Gallery" Typography Scale
///
/// Font pairing strategy:
/// - **DM Serif Display** — Scores & large numbers (serif elegance for gallery aesthetic)
/// - **Outfit** — Headlines & labels (geometric sans-serif, letter-spacing: +0.02em)
/// - **JetBrains Mono** — CSS values & distance display (monospace for technical data)
/// - **System font** — Body text (Hiragino Sans for Japanese support, reduces bundle size)
extension Font {
    // MARK: - Display (DM Serif Display — scores, large numbers)
    /// 72pt — Hero score display (gold accent)
    static let mdDisplayLarge = Font.custom("DMSerifDisplay-Regular", size: 72)
    /// 48pt — Secondary score display
    static let mdDisplayMedium = Font.custom("DMSerifDisplay-Regular", size: 48)
    /// 36pt — Tertiary display
    static let mdDisplaySmall = Font.custom("DMSerifDisplay-Regular", size: 36)

    // MARK: - Headline (Outfit Bold/SemiBold — titles, headings)
    /// 32pt Bold — Primary heading
    static let mdHeadlineLarge = Font.custom("Outfit", size: 32).weight(.bold)
    /// 28pt SemiBold — Secondary heading
    static let mdHeadlineMedium = Font.custom("Outfit", size: 28).weight(.semibold)
    /// 24pt SemiBold — Tertiary heading
    static let mdHeadlineSmall = Font.custom("Outfit", size: 24).weight(.semibold)

    // MARK: - Title (Outfit Medium/SemiBold)
    /// 22pt SemiBold — Large title
    static let mdTitleLarge = Font.custom("Outfit", size: 22).weight(.semibold)
    /// 16pt Medium — Medium title
    static let mdTitleMedium = Font.custom("Outfit", size: 16).weight(.medium)
    /// 14pt Medium — Small title
    static let mdTitleSmall = Font.custom("Outfit", size: 14).weight(.medium)

    // MARK: - Body (System font — Hiragino Sans for Japanese support)
    /// 16pt Regular — Large body text
    static let mdBodyLarge = Font.system(size: 16, weight: .regular)
    /// 14pt Regular — Medium body text
    static let mdBodyMedium = Font.system(size: 14, weight: .regular)
    /// 12pt Regular — Small body text
    static let mdBodySmall = Font.system(size: 12, weight: .regular)

    // MARK: - Label (Outfit Medium — UI labels, buttons)
    /// 14pt Medium — Large label
    static let mdLabelLarge = Font.custom("Outfit", size: 14).weight(.medium)
    /// 12pt Medium — Medium label
    static let mdLabelMedium = Font.custom("Outfit", size: 12).weight(.medium)
    /// 11pt Medium — Small label
    static let mdLabelSmall = Font.custom("Outfit", size: 11).weight(.medium)

    // MARK: - Monospace (JetBrains Mono — CSS values, distances)
    /// 12pt — Technical data display (use with textMuted color)
    static let mdMono = Font.custom("JetBrainsMono-Regular", size: 12)

}

extension View {
    /// Applies tabular (monospaced) digit rendering for number alignment.
    /// Use on score displays to prevent digit shifting during count-up animations.
    func tabularFigures() -> some View {
        monospacedDigit()
    }
}
