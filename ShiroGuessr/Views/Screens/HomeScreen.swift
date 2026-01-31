//
//  HomeScreen.swift
//  ShiroGuessr
//
//  Home screen for ShiroGuessr
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Logo and title
                VStack(spacing: 16) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(Color.mdPrimary)

                    Text("白Guessr")
                        .font(Font.mdDisplayLarge)
                        .foregroundColor(Color.mdOnBackground)
                        .fontWeight(.bold)

                    Text("Find the exact shade of white")
                        .font(Font.mdBodyLarge)
                        .foregroundColor(Color.mdOnSurfaceVariant)
                }

                Spacer()

                // Game mode buttons
                VStack(spacing: 16) {
                    NavigationLink(destination: ClassicGameScreen()) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                            Text("Classic Mode")
                        }
                        .font(.mdLabelLarge)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundStyle(Color.mdOnPrimary)
                        .background(Color.mdPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }

                    NavigationLink(destination: MapGameScreen()) {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Map Mode")
                        }
                        .font(.mdLabelLarge)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundStyle(Color.mdOnSecondaryContainer)
                        .background(Color.mdSecondaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mdBackground)
        }
    }
}

#Preview {
    HomeScreen()
}
