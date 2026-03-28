import SwiftUI

/// Dialog displaying the result of a single round
/// Redesigned with circular color comparison, progress ring score, and star rating.
/// Entrance animations use tween (300ms EaseInOut) for smooth sheet presentation.
struct RoundResultDialog: View {
    let round: GameRound
    let onNext: () -> Void

    @State private var animateContent = false
    @State private var ringProgress: Double = 0.0

    /// Star rating based on Manhattan distance (0-30 range)
    /// 0-2: 5 stars, 3-5: 4 stars, 6-10: 3 stars, 11-18: 2 stars, 19+: 1 star
    private var starRating: Int {
        let distance = round.distance ?? 30
        switch distance {
        case 0...2: return 5
        case 3...5: return 4
        case 6...10: return 3
        case 11...18: return 2
        default: return 1
        }
    }

    /// Score progress as a fraction of 1000
    private var scoreProgress: Double {
        Double(round.score ?? 0) / 1000.0
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text(L10n.RoundResult.title(round.roundNumber))
                .font(.mdHeadlineMedium)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.bold)
                .padding(.bottom, 4)

            // Color comparison — large circles side by side with "vs"
            colorComparisonSection
                .opacity(animateContent ? 1.0 : 0.0)

            // Distance — large gold number as primary metric
            distanceSection
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.8)

            // Score — progress ring visualization
            scoreRingSection

            // Star rating
            starRatingSection
                .opacity(animateContent ? 1.0 : 0.0)

            // Next button
            Button {
                onNext()
            } label: {
                HStack {
                    Text(L10n.RoundResult.continue)
                    Image(systemName: "arrow.right.circle.fill")
                }
                .font(.mdLabelLarge)
            }
            .buttonStyle(.mdFilled)
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(AnimationConstants.tweenShort) {
                animateContent = true
            }
            // Animate the progress ring with a tween
            withAnimation(AnimationConstants.tweenLong.delay(0.15)) {
                ringProgress = scoreProgress
            }
        }
    }

    // MARK: - Color Comparison

    @ViewBuilder
    private var colorComparisonSection: some View {
        HStack(spacing: 16) {
            // Target color circle
            VStack(spacing: 8) {
                Text(L10n.RoundResult.target)
                    .font(.mdLabelMedium)
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                Circle()
                    .fill(round.targetColor.toColor())
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.sampleBorder, lineWidth: 1.5)
                    )
                    .shadow(color: Color.sampleShadow, radius: 4, x: 0, y: 2)

                Text(round.targetColor.toCSSString())
                    .font(.mdMono)
                    .foregroundStyle(Color.textMuted)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Accessibility.targetColor(round.targetColor.toCSSString()))

            // "vs" separator
            Text("vs")
                .font(.mdLabelLarge)
                .foregroundStyle(Color.mdOnSurfaceVariant)
                .padding(.top, 20) // Align with circle centers
                .accessibilityHidden(true)

            // Selected color circle
            VStack(spacing: 8) {
                Text(L10n.RoundResult.yourGuess)
                    .font(.mdLabelMedium)
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                if let selectedColor = round.selectedColor {
                    Circle()
                        .fill(selectedColor.toColor())
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.sampleBorder, lineWidth: 1.5)
                        )
                        .shadow(color: Color.sampleShadow, radius: 4, x: 0, y: 2)

                    Text(selectedColor.toCSSString())
                        .font(.mdMono)
                        .foregroundStyle(Color.textMuted)
                } else {
                    Circle()
                        .fill(Color.mdSurfaceVariant)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.sampleBorder, lineWidth: 1.5)
                        )

                    Text("---")
                        .font(.mdMono)
                        .foregroundStyle(Color.textMuted)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                round.selectedColor.map { L10n.Accessibility.yourGuessColor($0.toCSSString()) }
                    ?? L10n.Accessibility.noGuess
            )
        }
    }

    // MARK: - Distance Display

    @ViewBuilder
    private var distanceSection: some View {
        VStack(spacing: 4) {
            Text(L10n.RoundResult.distance)
                .font(.mdLabelMedium)
                .foregroundStyle(Color.mdOnSurfaceVariant)

            Text("\(round.distance ?? 0)")
                .font(.mdDisplayMedium)
                .foregroundStyle(Color.mdPrimary)
                .tabularFigures()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Accessibility.colorDistance(round.distance ?? 0))
    }

    // MARK: - Score Ring

    @ViewBuilder
    private var scoreRingSection: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color.mdSurfaceVariant, lineWidth: 8)
                    .frame(width: 100, height: 100)

                // Progress ring — animated from 0 to scoreProgress on appear
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        Color.mdPrimary,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                // Score text inside ring
                VStack(spacing: 2) {
                    Text("\(round.score ?? 0)")
                        .font(.mdHeadlineSmall)
                        .foregroundStyle(Color.mdPrimary)
                        .tabularFigures()

                    Text("/ 1000")
                        .font(.mdLabelSmall)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Accessibility.roundScore(round.score ?? 0, 1000))
        }
    }

    // MARK: - Star Rating

    @ViewBuilder
    private var starRatingSection: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= starRating ? "star.fill" : "star")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.mdPrimary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Accessibility.starRating(starRating))
    }
}

#Preview {
    RoundResultDialog(
        round: GameRound(
            roundNumber: 1,
            targetColor: RGBColor(r: 250, g: 248, b: 252),
            selectedColor: RGBColor(r: 248, g: 250, b: 250),
            distance: 6,
            score: 800,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        ),
        onNext: {}
    )
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
}

#Preview("High Score") {
    RoundResultDialog(
        round: GameRound(
            roundNumber: 3,
            targetColor: RGBColor(r: 252, g: 250, b: 248),
            selectedColor: RGBColor(r: 252, g: 250, b: 249),
            distance: 1,
            score: 967,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        ),
        onNext: {}
    )
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
}

#Preview("Low Score") {
    RoundResultDialog(
        round: GameRound(
            roundNumber: 5,
            targetColor: RGBColor(r: 245, g: 255, b: 248),
            selectedColor: RGBColor(r: 255, g: 245, b: 255),
            distance: 22,
            score: 267,
            paletteColors: [],
            pin: nil,
            targetPin: nil,
            timeRemaining: nil
        ),
        onNext: {}
    )
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
}
