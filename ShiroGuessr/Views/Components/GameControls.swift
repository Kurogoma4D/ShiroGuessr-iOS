import SwiftUI

/// Control buttons for game actions (submit and next)
struct GameControls: View {
    let canSubmit: Bool
    let canProceed: Bool
    let onSubmit: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Submit button (shown before submitting answer)
            if !canProceed {
                Button(action: onSubmit) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.mdLabelLarge)
                        Text("Submit Answer")
                            .font(.mdLabelLarge)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(Color.mdOnPrimary)
                    .background(canSubmit ? Color.mdPrimary : Color.mdOutlineVariant)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .disabled(!canSubmit)
            }

            // Next button (shown after submitting answer)
            if canProceed {
                Button(action: onNext) {
                    HStack {
                        Text("Next Round")
                            .font(.mdLabelLarge)
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.mdLabelLarge)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(Color.mdOnPrimary)
                    .background(Color.mdPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.3), value: canProceed)
    }
}

#Preview {
    VStack(spacing: 32) {
        Text("Submit Button - Disabled")
            .font(.mdTitleMedium)
        GameControls(
            canSubmit: false,
            canProceed: false,
            onSubmit: {},
            onNext: {}
        )

        Text("Submit Button - Enabled")
            .font(.mdTitleMedium)
        GameControls(
            canSubmit: true,
            canProceed: false,
            onSubmit: {},
            onNext: {}
        )

        Text("Next Button")
            .font(.mdTitleMedium)
        GameControls(
            canSubmit: false,
            canProceed: true,
            onSubmit: {},
            onNext: {}
        )
    }
    .padding()
    .background(Color.mdBackground)
}
