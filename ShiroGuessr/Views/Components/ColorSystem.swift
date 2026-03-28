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
    static let mdTertiary = Color(red: 0.545, green: 0.478, blue: 0.369)
    static let mdOnTertiary = Color(red: 0.051, green: 0.051, blue: 0.071)
    static let mdTertiaryContainer = Color(red: 0.145, green: 0.145, blue: 0.188)
    static let mdOnTertiaryContainer = Color(red: 0.910, green: 0.902, blue: 0.890)

    // MARK: - Error / Feedback
    /// Low score / error — muted red (#C87E7E)
    static let mdError = Color(red: 0.784, green: 0.494, blue: 0.494)
    static let mdOnError = Color(red: 0.051, green: 0.051, blue: 0.071)
    /// Error container — dark red (#2A2020)
    static let mdErrorContainer = Color(red: 0.165, green: 0.125, blue: 0.125)
    /// Error text on container (#C87E7E)
    static let mdOnErrorContainer = Color(red: 0.784, green: 0.494, blue: 0.494)

    // MARK: - On-Surface Text
    /// Main text — slightly warm off-white (#E8E6E3)
    static let mdOnBackground = Color(red: 0.910, green: 0.902, blue: 0.890)
    /// Main text on surfaces (#E8E6E3)
    static let mdOnSurface = Color(red: 0.910, green: 0.902, blue: 0.890)
    /// Secondary text (#9995A0)
    static let mdOnSurfaceVariant = Color(red: 0.600, green: 0.584, blue: 0.627)

    // MARK: - Outline Colors
    /// Border around color samples (#3A3A45)
    static let mdOutline = Color(red: 0.227, green: 0.227, blue: 0.271)
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
    /// Border around color samples (#3A3A45)
    static let sampleBorder = Color(red: 0.227, green: 0.227, blue: 0.271)
    /// Drop shadow for color samples (rgba(0,0,0,0.4))
    static let sampleShadow = Color.black.opacity(0.4)
    /// Neutral-gray mid-value frame for color sample areas (#787880)
    static let sampleFrame = Color(red: 0.471, green: 0.471, blue: 0.502)
}

/// Material Design 3 Typography Scale
extension Font {
    // Display
    static let mdDisplayLarge = Font.system(size: 57, weight: .regular)
    static let mdDisplayMedium = Font.system(size: 45, weight: .regular)
    static let mdDisplaySmall = Font.system(size: 36, weight: .regular)

    // Headline
    static let mdHeadlineLarge = Font.system(size: 32, weight: .regular)
    static let mdHeadlineMedium = Font.system(size: 28, weight: .regular)
    static let mdHeadlineSmall = Font.system(size: 24, weight: .regular)

    // Title
    static let mdTitleLarge = Font.system(size: 22, weight: .medium)
    static let mdTitleMedium = Font.system(size: 16, weight: .medium)
    static let mdTitleSmall = Font.system(size: 14, weight: .medium)

    // Body
    static let mdBodyLarge = Font.system(size: 16, weight: .regular)
    static let mdBodyMedium = Font.system(size: 14, weight: .regular)
    static let mdBodySmall = Font.system(size: 12, weight: .regular)

    // Label
    static let mdLabelLarge = Font.system(size: 14, weight: .medium)
    static let mdLabelMedium = Font.system(size: 12, weight: .medium)
    static let mdLabelSmall = Font.system(size: 11, weight: .medium)
}
