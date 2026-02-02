//
//  TutorialBottomSheet.swift
//  ShiroGuessr
//
//  Material Design 3 tutorial bottom sheet for first-time users
//

import SwiftUI

struct TutorialBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0

    private let pages: [TutorialPage] = [
        TutorialPage(
            icon: "paintpalette.fill",
            iconColor: .mdPrimary,
            title: L10n.Tutorial.welcome,
            description: L10n.Tutorial.welcomeDescription
        ),
        TutorialPage(
            icon: "target",
            iconColor: .mdSecondary,
            title: L10n.Tutorial.howToPlay,
            description: L10n.Tutorial.howToPlayDescription
        ),
        TutorialPage(
            icon: "map.fill",
            iconColor: .mdTertiary,
            title: L10n.Tutorial.gameModes,
            description: L10n.Tutorial.gameModesDescription
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            dragHandle

            // Content
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    TutorialPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 420)

            // Bottom action
            actionButton
        }
        .background(Color.mdSurface)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.mdOnSurfaceVariant.opacity(0.4))
            .frame(width: 32, height: 4)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }

    private var actionButton: some View {
        Button(action: {
            if currentPage < pages.count - 1 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentPage += 1
                }
            } else {
                isPresented = false
                TutorialManager.shared.markTutorialAsShown()
            }
        }) {
            Text(currentPage < pages.count - 1 ? L10n.Tutorial.next : L10n.Tutorial.getStarted)
                .font(.mdLabelLarge)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundStyle(Color.mdOnPrimary)
                .background(Color.mdPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .padding(.top, 16)
    }
}

struct TutorialPage {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(page.iconColor)
                .symbolRenderingMode(.hierarchical)

            // Title
            Text(page.title)
                .font(.mdHeadlineLarge)
                .foregroundColor(.mdOnSurface)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // Description
            Text(page.description)
                .font(.mdBodyLarge)
                .foregroundColor(.mdOnSurfaceVariant)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.vertical, 24)
    }
}

#Preview("Tutorial Sheet") {
    Color.black.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            TutorialBottomSheet(isPresented: .constant(true))
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
        }
}
