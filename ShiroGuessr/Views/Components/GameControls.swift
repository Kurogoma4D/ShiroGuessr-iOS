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
                Button {
                    onSubmit()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text(L10n.Controls.submitAnswer)
                    }
                    .font(.mdLabelLarge)
                }
                .buttonStyle(.mdFilled)
                .disabled(!canSubmit)
            }

            // Next button (shown after submitting answer)
            if canProceed {
                Button {
                    onNext()
                } label: {
                    HStack {
                        Text(L10n.Controls.nextRound)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.mdLabelLarge)
                }
                .buttonStyle(.mdFilled)
            }
        }
        .padding(.horizontal, 16)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: canProceed)
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
