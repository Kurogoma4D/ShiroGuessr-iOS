import SwiftUI

/// Screen displaying final game results with particle effects, score count-up,
/// star ratings, and improved action buttons per Shiro Gallery design (Section 5.6)
struct ResultScreen: View {
    let gameState: GameState
    let onReplay: () -> Void
    var onBackToHome: (() -> Void)?

    @State private var animateScore = false
    @State private var animateRounds = false
    @State private var countUpValue: Int = 0
    @State private var countUpComplete = false
    @State private var showBurst = false
    @State private var countUpTask: Task<Void, Never>?
    @StateObject private var adManager = InterstitialAdManager.shared

    /// Whether the score qualifies for particle effects (3000+)
    private var showParticles: Bool {
        gameState.totalScore >= 3000
    }

    /// Burst tier based on total score
    private var burstTier: BurstTier {
        if gameState.totalScore >= 4000 { return .large }
        if gameState.totalScore >= 3000 { return .small }
        return .none
    }

    /// Score color that transitions during count-up: low -> mid -> high
    private var scoreColor: Color {
        let ratio = Double(countUpValue) / 5000.0
        if ratio < 0.4 {
            return Color.scoreLow
        } else if ratio < 0.7 {
            // Interpolate between low and mid
            let t = (ratio - 0.4) / 0.3
            return interpolateColor(from: Color.scoreLow, to: Color.scoreMid, t: t)
        } else {
            // Interpolate between mid and high
            let t = (ratio - 0.7) / 0.3
            return interpolateColor(from: Color.scoreMid, to: Color.scoreHigh, t: t)
        }
    }

    var body: some View {
        ZStack {
            // Background
            Color.mdBackground.ignoresSafeArea()

            // Particle effect layer (high scores only)
            if showParticles {
                GoldParticleView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Round results with staggered fade-in
                    roundResultsSection

                    // Action buttons
                    actionButtonsSection
                }
            }

            // Burst effect overlay
            if showBurst && burstTier != .none {
                BurstEffectView(tier: burstTier)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
        }
        .onAppear {
            startAnimations()
        }
        .onDisappear {
            countUpTask?.cancel()
        }
    }

    // MARK: - Header Section

    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.mdPrimary)
                .scaleEffect(animateScore ? 1.0 : 0.5)
                .opacity(animateScore ? 1.0 : 0.0)

            Text(L10n.Result.gameComplete)
                .font(.mdHeadlineLarge)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.bold)
                .opacity(animateScore ? 1.0 : 0.0)

            // Total score with count-up and color transition
            VStack(spacing: 4) {
                Text(L10n.Result.totalScore)
                    .font(.mdLabelMedium)
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                Text("\(countUpValue)")
                    .font(.mdDisplayLarge)
                    .foregroundStyle(scoreColor)
                    .tabularFigures()
                    .contentTransition(.numericText(countsDown: false))

                Text(L10n.Result.outOf5000)
                    .font(.mdBodyMedium)
                    .foregroundStyle(Color.mdOnSurfaceVariant)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(Color.mdPrimaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(animateScore ? 1.0 : 0.8)
            .scaleEffect(showBurst ? 1.05 : 1.0)
            .opacity(animateScore ? 1.0 : 0.0)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Accessibility.totalScore(gameState.totalScore, 5000))
        }
        .padding(.top, 32)
    }

    // MARK: - Round Results Section

    @ViewBuilder
    private var roundResultsSection: some View {
        VStack(spacing: 12) {
            Text(L10n.Result.roundResults)
                .font(.mdTitleLarge)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .opacity(animateRounds ? 1.0 : 0.0)

            ForEach(gameState.rounds.indices, id: \.self) { index in
                RoundResultCard(round: gameState.rounds[index])
                    .opacity(animateRounds ? 1.0 : 0.0)
                    .offset(y: animateRounds ? 0 : 20)
                    .animation(
                        AnimationConstants.tweenShort
                            .delay(Double(index) * AnimationConstants.staggerInterval),
                        value: animateRounds
                    )
            }
        }
    }

    // MARK: - Action Buttons Section

    @ViewBuilder
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            // Play Again — gold filled, most prominent
            Button {
                handlePlayAgain()
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                    Text(L10n.Result.playAgain)
                }
                .font(.mdLabelLarge)
            }
            .buttonStyle(.mdFilled)

            // Share & Copy — outlined buttons, side by side
            HStack(spacing: 12) {
                ShareButton(gameState: gameState, useOutlinedStyle: true)

                Button {
                    copyToClipboard()
                } label: {
                    HStack {
                        Image(systemName: "doc.on.clipboard")
                        Text(L10n.Result.copyToClipboard)
                    }
                    .font(.mdLabelLarge)
                }
                .buttonStyle(.mdOutlined)
            }

            if let onBackToHome {
                Button {
                    onBackToHome()
                } label: {
                    HStack {
                        Image(systemName: "house")
                        Text(L10n.Result.home)
                    }
                    .font(.mdLabelLarge)
                }
                .buttonStyle(.mdText)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    // MARK: - Animations

    private func startAnimations() {
        // Phase 1: Score area entrance — tween fade/scale in (500ms EaseInOut)
        withAnimation(AnimationConstants.tweenLong) {
            animateScore = true
        }

        // Phase 2: Count-up score with color transition
        startCountUp()

        // Phase 3: Round results staggered fade-in (100ms intervals, tweenShort per item)
        withAnimation(AnimationConstants.tweenShort.delay(0.3)) {
            animateRounds = true
        }
    }

    private func startCountUp() {
        guard countUpValue == 0 else { return }
        let targetScore = gameState.totalScore
        let steps = 60
        let stepDuration: UInt64 = 25_000_000 // 25ms per step

        countUpTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(400))

            for step in 0...steps {
                guard !Task.isCancelled else { return }
                let progress = Double(step) / Double(steps)
                let easedProgress = 1.0 - pow(1.0 - progress, 3)
                withAnimation(.linear(duration: 0.025)) {
                    countUpValue = Int(Double(targetScore) * easedProgress)
                }

                if step == steps {
                    countUpValue = targetScore
                    countUpComplete = true
                    if burstTier != .none {
                        withAnimation(AnimationConstants.spring) {
                            showBurst = true
                        }
                        try? await Task.sleep(for: .milliseconds(400))
                        guard !Task.isCancelled else { return }
                        withAnimation(AnimationConstants.spring) {
                            showBurst = false
                        }
                    }
                } else {
                    try? await Task.sleep(nanoseconds: stepDuration)
                }
            }
        }
    }

    // MARK: - Helpers

    private func copyToClipboard() {
        let text = ShareService.generateShareText(gameState: gameState)
        ShareService.copyToClipboard(text)
    }

    private func handlePlayAgain() {
        adManager.showAd {
            onReplay()
        }
    }

    /// Linear interpolation between two colors
    private func interpolateColor(from: Color, to: Color, t: Double) -> Color {
        let t = max(0, min(1, t))
        var fr: CGFloat = 0, fg: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        UIColor(from).getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
        var tr: CGFloat = 0, tg: CGFloat = 0, tb: CGFloat = 0, ta: CGFloat = 0
        UIColor(to).getRed(&tr, green: &tg, blue: &tb, alpha: &ta)

        return Color(
            red: fr + (tr - fr) * t,
            green: fg + (tg - fg) * t,
            blue: fb + (tb - fb) * t
        )
    }
}

// MARK: - Burst Tier

enum BurstTier {
    case none
    case small
    case large
}

// MARK: - Gold Particle View

/// Subtle floating gold particles for high-score backgrounds
/// Implemented with TimelineView + Canvas per design guideline
struct GoldParticleView: View {
    @State private var particles: [Particle] = []

    private let particleCount = 30

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: CGFloat
        var wobblePhase: CGFloat
        var wobbleAmplitude: CGFloat
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for particle in particles {
                    let yOffset = CGFloat(time.truncatingRemainder(dividingBy: 100)) * particle.speed
                    let y = (particle.y - yOffset).truncatingRemainder(dividingBy: (size.height + 40)) + 20
                    let adjustedY = y < -20 ? y + size.height + 40 : y
                    let wobble = sin(CGFloat(time) * 0.5 + particle.wobblePhase) * particle.wobbleAmplitude
                    let x = particle.x * size.width + wobble

                    let rect = CGRect(
                        x: x - particle.size / 2,
                        y: adjustedY - particle.size / 2,
                        width: particle.size,
                        height: particle.size
                    )

                    // Gold glow effect
                    context.opacity = particle.opacity * 0.3
                    context.fill(
                        Circle().path(in: rect.insetBy(dx: -2, dy: -2)),
                        with: .color(Color.mdPrimary)
                    )

                    // Core particle
                    context.opacity = particle.opacity
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(Color.mdPrimary)
                    )
                }
            }
        }
        .onAppear {
            particles = (0..<particleCount).map { _ in
                Particle(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1000),
                    size: CGFloat.random(in: 2...5),
                    opacity: Double.random(in: 0.2...0.6),
                    speed: CGFloat.random(in: 8...25),
                    wobblePhase: CGFloat.random(in: 0...(.pi * 2)),
                    wobbleAmplitude: CGFloat.random(in: 5...20)
                )
            }
        }
    }
}

// MARK: - Burst Effect View

/// Score-dependent burst effect on count-up completion
struct BurstEffectView: View {
    let tier: BurstTier

    @State private var animate = false
    @State private var sizes: [CGFloat] = []

    private var burstCount: Int {
        switch tier {
        case .large: return 24
        case .small: return 12
        case .none: return 0
        }
    }

    private var maxRadius: CGFloat {
        switch tier {
        case .large: return 200
        case .small: return 120
        case .none: return 0
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height * 0.3)

            ZStack {
                ForEach(0..<burstCount, id: \.self) { index in
                    let angle = (Double(index) / Double(burstCount)) * 2 * .pi
                    let radius = animate ? maxRadius : 0
                    let x = center.x + cos(angle) * radius
                    let y = center.y + sin(angle) * radius
                    let size = index < sizes.count ? sizes[index] : 4.0

                    Circle()
                        .fill(Color.mdPrimary)
                        .frame(width: size, height: size)
                        .position(x: x, y: y)
                        .opacity(animate ? 0 : 1)
                }
            }
        }
        .onAppear {
            sizes = (0..<burstCount).map { _ in
                tier == .large ? CGFloat.random(in: 4...8) : CGFloat.random(in: 3...6)
            }
            withAnimation(Animation.easeOut(duration: 0.8)) {
                animate = true
            }
        }
    }
}

// MARK: - Round Result Card with Star Rating

/// Card displaying a single round result with star rating and enlarged color samples
private struct RoundResultCard: View {
    let round: GameRound

    /// Star rating based on Manhattan distance (0-30 range)
    /// Matches the rating logic from RoundResultDialog
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

    var body: some View {
        HStack(spacing: 12) {
            // Round number
            Text("\(round.roundNumber)")
                .font(.mdTitleLarge)
                .foregroundStyle(Color.mdOnPrimaryContainer)
                .fontWeight(.bold)
                .frame(width: 40, height: 40)
                .background(Color.mdPrimaryContainer)
                .clipShape(Circle())

            // Color previews — enlarged for dark background visibility
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(round.targetColor.toColor())
                    .frame(width: 44, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.sampleBorder, lineWidth: 1.5)
                    )
                    .shadow(color: Color.sampleShadow, radius: 2, x: 0, y: 1)

                Image(systemName: "arrow.right")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.mdOnSurfaceVariant)

                if let selectedColor = round.selectedColor {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedColor.toColor())
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.sampleBorder, lineWidth: 1.5)
                        )
                        .shadow(color: Color.sampleShadow, radius: 2, x: 0, y: 1)
                }
            }

            // Star rating — small, next to color circles
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= starRating ? "star.fill" : "star")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.mdPrimary)
                }
            }
            .accessibilityHidden(true)

            Spacer()

            // Score
            Text("\(round.score ?? 0)")
                .font(.mdMono)
                .foregroundStyle(Color.mdPrimary)
        }
        .padding(12)
        .cardPanelStyle()
        .padding(.horizontal, 16)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Accessibility.roundResult(
            round.roundNumber,
            round.score ?? 0,
            starRating
        ))
    }
}


// MARK: - Preview

#Preview("High Score") {
    ResultScreen(
        gameState: GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 248, g: 250, b: 250),
                    distance: 2,
                    score: 934,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 2,
                    targetColor: RGBColor(r: 255, g: 255, b: 255),
                    selectedColor: RGBColor(r: 255, g: 255, b: 255),
                    distance: 0,
                    score: 1000,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 3,
                    targetColor: RGBColor(r: 245, g: 250, b: 248),
                    selectedColor: RGBColor(r: 248, g: 248, b: 250),
                    distance: 7,
                    score: 766,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 4,
                    targetColor: RGBColor(r: 252, g: 245, b: 255),
                    selectedColor: RGBColor(r: 250, g: 248, b: 252),
                    distance: 7,
                    score: 766,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 5,
                    targetColor: RGBColor(r: 248, g: 252, b: 245),
                    selectedColor: RGBColor(r: 250, g: 250, b: 248),
                    distance: 3,
                    score: 900,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 5,
            isCompleted: true,
            totalScore: 4366,
            timeLimit: nil
        ),
        onReplay: {}
    )
}

#Preview("Low Score") {
    ResultScreen(
        gameState: GameState(
            rounds: [
                GameRound(
                    roundNumber: 1,
                    targetColor: RGBColor(r: 250, g: 248, b: 252),
                    selectedColor: RGBColor(r: 248, g: 250, b: 250),
                    distance: 15,
                    score: 500,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 2,
                    targetColor: RGBColor(r: 255, g: 255, b: 255),
                    selectedColor: RGBColor(r: 245, g: 248, b: 252),
                    distance: 17,
                    score: 434,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 3,
                    targetColor: RGBColor(r: 245, g: 250, b: 248),
                    selectedColor: RGBColor(r: 255, g: 245, b: 255),
                    distance: 22,
                    score: 267,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 4,
                    targetColor: RGBColor(r: 252, g: 245, b: 255),
                    selectedColor: RGBColor(r: 245, g: 255, b: 245),
                    distance: 24,
                    score: 200,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
                GameRound(
                    roundNumber: 5,
                    targetColor: RGBColor(r: 248, g: 252, b: 245),
                    selectedColor: RGBColor(r: 255, g: 245, b: 255),
                    distance: 24,
                    score: 200,
                    paletteColors: [],
                    pin: nil,
                    targetPin: nil,
                    timeRemaining: nil
                ),
            ],
            currentRoundIndex: 5,
            isCompleted: true,
            totalScore: 1601,
            timeLimit: nil
        ),
        onReplay: {}
    )
}
