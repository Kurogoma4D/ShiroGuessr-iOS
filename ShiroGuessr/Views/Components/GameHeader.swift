import SwiftUI

/// Header component displaying game title and mode toggle
struct GameHeader: View {
    var body: some View {
        HStack {
            Text("白Guessr")
                .font(.mdHeadlineLarge)
                .foregroundStyle(Color.mdOnSurface)
                .fontWeight(.bold)

            Spacer()

            Button(action: {
                // Mode toggle functionality will be implemented later
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "gamecontroller")
                        .font(.mdLabelMedium)
                    Text("Mode")
                        .font(.mdLabelMedium)
                }
                .foregroundStyle(Color.mdOnSecondaryContainer)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.mdSecondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.mdSurface)
    }
}

#Preview {
    GameHeader()
}
