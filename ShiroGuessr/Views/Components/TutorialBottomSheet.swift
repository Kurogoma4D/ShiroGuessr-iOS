//
//  TutorialBottomSheet.swift
//  ShiroGuessr
//
//  Full-screen overlay tutorial for first-time users.
//  "Shiro Gallery" style: dark background with card-style content and simple diagrams.
//

import SwiftUI

struct TutorialOverlay: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0

    private let pageCount = 3

    var body: some View {
        ZStack {
            // Dark background
            Color.mdBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Card content with crossfade
                cardContent
                    .padding(.horizontal, 24)

                Spacer()

                // Page indicators
                pageIndicators
                    .padding(.bottom, 32)

                // Action button
                actionButton
                    .padding(.bottom, 48)
            }
        }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        ZStack {
            // Page 1: Two white samples side by side
            TutorialDiagramPage1(
                title: L10n.Tutorial.welcome,
                description: L10n.Tutorial.welcomeDescription
            )
            .opacity(currentPage == 0 ? 1 : 0)

            // Page 2: Palette tap-to-select diagram
            TutorialDiagramPage2(
                title: L10n.Tutorial.howToPlay,
                description: L10n.Tutorial.howToPlayDescription
            )
            .opacity(currentPage == 1 ? 1 : 0)

            // Page 3: Gradient map with pin diagram
            TutorialDiagramPage3(
                title: L10n.Tutorial.gameModes,
                description: L10n.Tutorial.gameModesDescription
            )
            .opacity(currentPage == 2 ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.4), value: currentPage)
    }

    // MARK: - Page Indicators

    private var pageIndicators: some View {
        HStack(spacing: 12) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.mdPrimary : Color.textMuted)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }

    // MARK: - Action Button

    private var actionButton: some View {
        Button(action: {
            if currentPage < pageCount - 1 {
                currentPage += 1
            } else {
                isPresented = false
                TutorialManager.shared.markTutorialAsShown()
            }
        }) {
            Text(currentPage < pageCount - 1 ? L10n.Tutorial.next : L10n.Tutorial.getStarted)
                .font(.mdLabelLarge)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundStyle(Color.mdOnPrimary)
                .background(Color.mdPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.3), radius: 8, y: 2)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Tutorial Card Container

/// Reusable card container for tutorial pages
private struct TutorialCard<Diagram: View>: View {
    let title: String
    let description: String
    @ViewBuilder let diagram: () -> Diagram

    var body: some View {
        VStack(spacing: 0) {
            // Diagram area
            diagram()
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .padding(.top, 32)
                .padding(.bottom, 24)

            // Title
            Text(title)
                .font(.mdHeadlineMedium)
                .foregroundColor(.mdOnSurface)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            // Description
            Text(description)
                .font(.mdBodyLarge)
                .foregroundColor(.mdOnSurfaceVariant)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
        }
        .background(Color.mdSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mdOutlineVariant, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 16, y: 4)
    }
}

// MARK: - Page 1: Two White Samples Side by Side

/// "They look the same, but they're different"
private struct TutorialDiagramPage1: View {
    let title: String
    let description: String

    // Two subtly different white colors
    private let colorLeft = Color(red: 252/255, green: 250/255, blue: 248/255)
    private let colorRight = Color(red: 248/255, green: 252/255, blue: 255/255)

    var body: some View {
        TutorialCard(title: title, description: description) {
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    // Left sample
                    colorSample(color: colorLeft, label: "A")

                    // "vs" text
                    Text("vs")
                        .font(.mdBodyLarge)
                        .foregroundColor(.textMuted)

                    // Right sample
                    colorSample(color: colorRight, label: "B")
                }

                // Subtitle
                Text("=?")
                    .font(.mdTitleMedium)
                    .foregroundColor(.mdOnSurfaceVariant)
            }
        }
    }

    private func colorSample(color: Color, label: String) -> some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.sampleBorder, lineWidth: 1.5)
                )
                .shadow(color: .sampleShadow, radius: 6, y: 2)

            Text(label)
                .font(.mdLabelMedium)
                .foregroundColor(.textMuted)
        }
    }
}

// MARK: - Page 2: Palette Tap-to-Select Diagram

/// Diagram showing a palette with one cell selected
private struct TutorialDiagramPage2: View {
    let title: String
    let description: String

    // Generate subtle white palette colors
    private let paletteColors: [[Color]] = {
        let baseColors: [[Color]] = [
            [
                Color(red: 250/255, green: 248/255, blue: 252/255),
                Color(red: 252/255, green: 250/255, blue: 248/255),
                Color(red: 248/255, green: 252/255, blue: 250/255),
                Color(red: 254/255, green: 250/255, blue: 248/255),
                Color(red: 248/255, green: 250/255, blue: 254/255),
            ],
            [
                Color(red: 252/255, green: 252/255, blue: 248/255),
                Color(red: 248/255, green: 248/255, blue: 252/255),
                Color(red: 250/255, green: 254/255, blue: 250/255),
                Color(red: 254/255, green: 248/255, blue: 252/255),
                Color(red: 250/255, green: 252/255, blue: 254/255),
            ],
            [
                Color(red: 248/255, green: 250/255, blue: 248/255),
                Color(red: 252/255, green: 248/255, blue: 250/255),
                Color(red: 250/255, green: 250/255, blue: 254/255),
                Color(red: 254/255, green: 252/255, blue: 248/255),
                Color(red: 248/255, green: 254/255, blue: 252/255),
            ],
        ]
        return baseColors
    }()

    // Selected cell position
    private let selectedRow = 1
    private let selectedCol = 3

    var body: some View {
        TutorialCard(title: title, description: description) {
            VStack(spacing: 12) {
                // Mini palette grid (3x5)
                VStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(0..<5, id: \.self) { col in
                                let isSelected = row == selectedRow && col == selectedCol
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(paletteColors[row][col])
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                isSelected ? Color.mdPrimary : Color.sampleBorder,
                                                lineWidth: isSelected ? 2.5 : 1
                                            )
                                    )
                                    .scaleEffect(isSelected ? 1.05 : 1.0)
                            }
                        }
                    }
                }

                // Tap indicator
                HStack(spacing: 4) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 14))
                    Text("Tap")
                        .font(.mdLabelSmall)
                }
                .foregroundColor(.mdPrimary)
            }
        }
    }
}

// MARK: - Page 3: Gradient Map with Pin Diagram

/// Diagram showing a gradient map with a pin placed on it
private struct TutorialDiagramPage3: View {
    let title: String
    let description: String

    // Corner colors for the gradient
    private let topLeft = Color(red: 248/255, green: 252/255, blue: 255/255)
    private let topRight = Color(red: 255/255, green: 248/255, blue: 250/255)
    private let bottomLeft = Color(red: 252/255, green: 255/255, blue: 248/255)
    private let bottomRight = Color(red: 255/255, green: 250/255, blue: 252/255)

    var body: some View {
        TutorialCard(title: title, description: description) {
            VStack(spacing: 12) {
                // Gradient map
                ZStack {
                    // Simplified gradient representation
                    gradientMap
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.mdOutline, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 8, y: 2)

                    // Pin
                    pinView
                        .offset(x: 24, y: -16)
                }

                // Pin label
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 14))
                    Text("Pin")
                        .font(.mdLabelSmall)
                }
                .foregroundColor(.mdPrimary)
            }
        }
    }

    private var gradientMap: some View {
        // Bilinear gradient approximation using overlapping linear gradients
        ZStack {
            LinearGradient(
                colors: [topLeft, topRight],
                startPoint: .leading,
                endPoint: .trailing
            )

            LinearGradient(
                colors: [bottomLeft.opacity(0.5), bottomRight.opacity(0.5)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                LinearGradient(
                    colors: [.clear, .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }

    private var pinView: some View {
        ZStack {
            // Pin shadow
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: 20, height: 20)
                .offset(y: 2)

            // Pin body
            Circle()
                .fill(Color.mdPrimary)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .stroke(Color.mdOnPrimary, lineWidth: 2)
                )
        }
    }
}

// MARK: - Legacy Compatibility

/// Type alias for backward compatibility with existing references
typealias TutorialBottomSheet = TutorialOverlay

// MARK: - Preview

#Preview("Tutorial Overlay") {
    TutorialOverlay(isPresented: .constant(true))
        .preferredColorScheme(.dark)
}
