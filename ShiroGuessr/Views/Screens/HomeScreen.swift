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
                .font(.mdDisplayMedium)
                .foregroundColor(.mdOnBackground)

            Text("Welcome to ShiroGuessr iOS")
                .font(.mdBodyLarge)
                .foregroundColor(.mdOnSurfaceVariant)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mdBackground)
    }
}

#Preview {
    HomeScreen()
}
