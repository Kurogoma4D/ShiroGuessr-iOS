//
//  ColorSystem.swift
//  ShiroGuessr
//
//  Material Design 3 Color System
//  Based on Material Design 3 guidelines: https://m3.material.io/
//

import SwiftUI

/// Material Design 3 Color System for ShiroGuessr
extension Color {
    // MARK: - Primary Colors
    static let mdPrimary = Color(red: 0.38, green: 0.49, blue: 0.98) // Material Blue
    static let mdOnPrimary = Color.white
    static let mdPrimaryContainer = Color(red: 0.87, green: 0.90, blue: 1.0)
    static let mdOnPrimaryContainer = Color(red: 0.0, green: 0.13, blue: 0.42)

    // MARK: - Secondary Colors
    static let mdSecondary = Color(red: 0.36, green: 0.43, blue: 0.62)
    static let mdOnSecondary = Color.white
    static let mdSecondaryContainer = Color(red: 0.85, green: 0.89, blue: 1.0)
    static let mdOnSecondaryContainer = Color(red: 0.06, green: 0.13, blue: 0.29)

    // MARK: - Tertiary Colors
    static let mdTertiary = Color(red: 0.63, green: 0.31, blue: 0.58)
    static let mdOnTertiary = Color.white
    static let mdTertiaryContainer = Color(red: 0.96, green: 0.85, blue: 0.94)
    static let mdOnTertiaryContainer = Color(red: 0.28, green: 0.06, blue: 0.25)

    // MARK: - Error Colors
    static let mdError = Color(red: 0.73, green: 0.11, blue: 0.11)
    static let mdOnError = Color.white
    static let mdErrorContainer = Color(red: 1.0, green: 0.85, blue: 0.85)
    static let mdOnErrorContainer = Color(red: 0.41, green: 0.0, blue: 0.0)

    // MARK: - Background Colors
    static let mdBackground = Color(red: 0.99, green: 0.99, blue: 1.0)
    static let mdOnBackground = Color(red: 0.11, green: 0.11, blue: 0.13)

    // MARK: - Surface Colors
    static let mdSurface = Color(red: 0.99, green: 0.99, blue: 1.0)
    static let mdOnSurface = Color(red: 0.11, green: 0.11, blue: 0.13)
    static let mdSurfaceVariant = Color(red: 0.88, green: 0.90, blue: 0.96)
    static let mdOnSurfaceVariant = Color(red: 0.27, green: 0.29, blue: 0.33)

    // MARK: - Outline Colors
    static let mdOutline = Color(red: 0.46, green: 0.47, blue: 0.52)
    static let mdOutlineVariant = Color(red: 0.78, green: 0.79, blue: 0.85)

    // MARK: - Shadow & Scrim
    static let mdShadow = Color.black.opacity(0.1)
    static let mdScrim = Color.black.opacity(0.32)
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
