import SwiftUI

/// Control buttons for game actions (submit and next).
///
/// The submit button triggers a brief ripple scale effect (100ms freeze)
/// before calling the submit callback, per the animation guideline.
struct GameControls: View {
    let canSubmit: Bool
    let canProceed: Bool
    let onSubmit: () -> Void
    let onNext: () -> Void

    @State private var isSubmitting = false

    var body: some View {
        VStack(spacing: 12) {
            // Submit button (shown before submitting answer)
            if !canProceed {
                Button {
                    guard !isSubmitting else { return }
                    triggerSubmit()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text(L10n.Controls.submitAnswer)
                    }
                    .font(.mdLabelLarge)
                }
                .buttonStyle(.mdFilled)
                .disabled(!canSubmit || isSubmitting)
                .scaleEffect(isSubmitting ? 0.95 : 1.0)
                .animation(AnimationConstants.quickResponse, value: isSubmitting)
                .accessibilityHint(canSubmit ? L10n.Accessibility.submitHint : "")
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
        .animation(AnimationConstants.spring, value: canProceed)
    }

    /// Triggers a brief freeze (100ms) with a scale ripple effect before calling onSubmit.
    private func triggerSubmit() {
        isSubmitting = true
        Task { @MainActor in
            try? await Task.sleep(
                nanoseconds: AnimationConstants.submitFreezeMilliseconds * 1_000_000
            )
            onSubmit()
            isSubmitting = false
        }
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
