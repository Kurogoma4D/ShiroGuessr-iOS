//
//  HomeScreen.swift
//  ShiroGuessr
//
//  Home screen for ShiroGuessr
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("ShiroGuessr")
                .font(Font.mdDisplayMedium)
                .foregroundColor(Color.mdOnBackground)

            Text("Welcome to ShiroGuessr iOS")
                .font(Font.mdBodyLarge)
                .foregroundColor(Color.mdOnSurfaceVariant)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mdBackground)
    }
}

#Preview {
    HomeScreen()
}
