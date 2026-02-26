import SwiftUI

/// A view modifier that applies `.presentationSizing(.form)` on iOS 18+.
/// This ensures sheets use a form-fitting size on iPad, while gracefully
/// degrading on older iOS versions.
struct FormPresentationSizingModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .presentationSizing(.form)
        } else {
            content
        }
    }
}
