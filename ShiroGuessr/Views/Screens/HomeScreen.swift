//
//  HomeScreen.swift
//  ShiroGuessr
//
//  Redesigned start screen with animated background, styled title,
//  and mode selection cards following Shiro Gallery design guideline (section 5.1).
//

import SwiftUI

/// Animated radial gradient background that slowly shifts on the dark canvas
struct AnimatedGradientBackground: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 10.0)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                // Slowly moving radial gradient center
                let cx = size.width * 0.5 + cos(t * 0.15) * size.width * 0.12
                let cy = size.height * 0.35 + sin(t * 0.12) * size.height * 0.08
                let center = CGPoint(x: cx, y: cy)
                let radius = max(size.width, size.height) * 0.7

                let gradient = Gradient(colors: [
                    Color.white.opacity(0.06),
                    Color.white.opacity(0.02),
                    Color.clear
                ])
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .radialGradient(
                        gradient,
                        center: center,
                        startRadius: 0,
                        endRadius: radius
                    )
                )
            }
        }
    }
}

/// Mode selection card for the start screen
struct ModeSelectionCard: View {
    let mode: GameMode
    let namespace: Namespace.ID
    let onTap: () -> Void

    private var title: String {
        switch mode {
        case .classicMode: return L10n.Home.classicMode
        case .mapMode: return L10n.Home.mapMode
        }
    }

    private var subtitle: String {
        switch mode {
        case .classicMode: return L10n.Home.classicModeSubtitle
        case .mapMode: return L10n.Home.mapModeSubtitle
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Mode icon with preview element
                modePreview
                    .frame(width: 64, height: 64)

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.mdHeadlineSmall)
                        .foregroundStyle(Color.mdOnSurface)

                    Text(subtitle)
                        .font(.mdBodyMedium)
                        .foregroundStyle(Color.mdOnSurfaceVariant)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.mdSecondary)
            }
            .padding(20)
            .background(Color.mdSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.mdOutlineVariant, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            .matchedGeometryEffect(id: mode, in: namespace)
        }
        .buttonStyle(CardButtonStyle())
    }

    @ViewBuilder
    private var modePreview: some View {
        switch mode {
        case .classicMode:
            // Palette icon: 3x3 grid of subtle white color cells
            classicPreview
        case .mapMode:
            // Gradient icon: mini gradient square
            mapPreview
        }
    }

    private var classicPreview: some View {
        let colors: [Color] = [
            Color(red: 0.98, green: 0.97, blue: 0.96),
            Color(red: 0.96, green: 0.98, blue: 0.97),
            Color(red: 0.97, green: 0.96, blue: 0.99),
            Color(red: 0.99, green: 0.97, blue: 0.96),
            Color(red: 0.96, green: 0.97, blue: 0.98),
            Color(red: 0.98, green: 0.99, blue: 0.97),
            Color(red: 0.97, green: 0.98, blue: 0.96),
            Color(red: 0.99, green: 0.96, blue: 0.98),
            Color(red: 0.96, green: 0.99, blue: 0.97),
        ]
        return VStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { col in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors[row * 3 + col])
                            .frame(width: 18, height: 18)
                    }
                }
            }
        }
        .padding(4)
        .background(Color.mdSurfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var mapPreview: some View {
        // Mini gradient map preview
        Canvas { context, size in
            let topLeft = Color(red: 0.98, green: 0.96, blue: 0.96)
            let topRight = Color(red: 0.96, green: 0.98, blue: 0.97)
            let bottomLeft = Color(red: 0.97, green: 0.97, blue: 0.99)
            let bottomRight = Color(red: 0.99, green: 0.98, blue: 0.96)

            // Draw a simple 2x2 block gradient approximation
            let halfW = size.width / 2
            let halfH = size.height / 2

            context.fill(Path(CGRect(x: 0, y: 0, width: halfW, height: halfH)),
                         with: .color(topLeft))
            context.fill(Path(CGRect(x: halfW, y: 0, width: halfW, height: halfH)),
                         with: .color(topRight))
            context.fill(Path(CGRect(x: 0, y: halfH, width: halfW, height: halfH)),
                         with: .color(bottomLeft))
            context.fill(Path(CGRect(x: halfW, y: halfH, width: halfW, height: halfH)),
                         with: .color(bottomRight))
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.mdOutline, lineWidth: 1)
        )
        .padding(4)
    }
}

/// Button style for mode selection cards with press feedback
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(AnimationConstants.springLight, value: configuration.isPressed)
    }
}

struct HomeScreen: View {
    @Namespace private var heroNamespace
    @State private var isTransitioning = false

    /// Transition uses tweenMedium (400ms EaseInOut) per animation guideline.
    private static let transitionDuration: TimeInterval = 0.4

    var body: some View {
        ZStack {
            // Dark canvas background
            Color.mdBackground
                .ignoresSafeArea()

            // Animated white radial gradient
            AnimatedGradientBackground()
                .ignoresSafeArea()
                .opacity(isTransitioning ? 0 : 1)

            // Content
            VStack(spacing: 0) {
                Spacer()

                // Title: "ShiroGuessr" with gold "Shiro" highlight
                titleView
                    .padding(.bottom, 8)

                // Tagline
                Text(L10n.Home.tagline)
                    .font(.mdBodyLarge)
                    .foregroundStyle(Color.mdOnSurfaceVariant)
                    .opacity(isTransitioning ? 0 : 1)

                Spacer()

                // Mode selection cards
                VStack(spacing: 16) {
                    ModeSelectionCard(
                        mode: .classicMode,
                        namespace: heroNamespace
                    ) {
                        selectMode(.classicMode)
                    }

                    ModeSelectionCard(
                        mode: .mapMode,
                        namespace: heroNamespace
                    ) {
                        selectMode(.mapMode)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
                .opacity(isTransitioning ? 0 : 1)
            }
        }
    }

    // MARK: - Title View

    @ViewBuilder
    private var titleView: some View {
        HStack(spacing: 0) {
            Text("Shiro")
                .font(.mdHeadlineLarge)
                .foregroundStyle(Color.mdPrimary)
            Text("Guessr")
                .font(.mdHeadlineLarge)
                .foregroundStyle(Color.mdOnSurface)
        }
        .opacity(isTransitioning ? 0 : 1)
    }

    // MARK: - Mode Selection

    private func selectMode(_ mode: GameMode) {
        guard !isTransitioning else { return }

        withAnimation(AnimationConstants.tweenMedium) {
            isTransitioning = true
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(Int(Self.transitionDuration * 1000)))
            NotificationCenter.default.post(
                name: .navigateToGame,
                object: mode
            )
        }
    }
}

// MARK: - Navigation Notification

extension Notification.Name {
    static let navigateToGame = Notification.Name("navigateToGame")
}

#Preview {
    HomeScreen()
}
