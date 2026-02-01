import SwiftUI

/// Launch screen following Material Design 3 principles
struct LaunchScreen: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Background
            Color.mdBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Logo with animation
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(Color.mdPrimary)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)

                // App name
                Text("白Guessr")
                    .font(.mdDisplayLarge)
                    .foregroundStyle(Color.mdOnBackground)
                    .fontWeight(.bold)
                    .opacity(isAnimating ? 1.0 : 0.0)

                // Tagline
                Text("Find the exact shade of white")
                    .font(.mdBodyLarge)
                    .foregroundStyle(Color.mdOnSurfaceVariant)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
