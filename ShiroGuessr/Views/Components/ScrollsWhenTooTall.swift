import SwiftUI

extension View {
    /// Scrolls only when the content's minimum height exceeds the available space, such as on
    /// iPhone in landscape. Otherwise the content keeps its full height so its Spacers still distribute it.
    func scrollsWhenTooTall() -> some View {
        ViewThatFits(in: .vertical) {
            self
            ScrollView { self }
        }
    }
}
