import SwiftUI

// MARK: - Material Design 3 Button Styles

/// Filled button style following Material Design 3
struct FilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(Color.mdOnPrimary)
            .background(isEnabled ? Color.mdPrimary : Color.mdOnSurface.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(
                color: configuration.isPressed ? Color.clear : Color.mdShadow,
                radius: configuration.isPressed ? 0 : 2,
                x: 0,
                y: configuration.isPressed ? 0 : 1
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// Filled tonal button style following Material Design 3
struct FilledTonalButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(isEnabled ? Color.mdOnSecondaryContainer : Color.mdOnSurface.opacity(0.38))
            .background(isEnabled ? Color.mdSecondaryContainer : Color.mdOnSurface.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(
                color: configuration.isPressed ? Color.clear : Color.mdShadow.opacity(0.3),
                radius: configuration.isPressed ? 0 : 1,
                x: 0,
                y: configuration.isPressed ? 0 : 1
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// Outlined button style following Material Design 3
struct OutlinedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(isEnabled ? Color.mdPrimary : Color.mdOnSurface.opacity(0.38))
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        isEnabled ? Color.mdOutline : Color.mdOnSurface.opacity(0.12),
                        lineWidth: 1
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// Elevated button style following Material Design 3
struct ElevatedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(isEnabled ? Color.mdPrimary : Color.mdOnSurface.opacity(0.38))
            .background(isEnabled ? Color.mdSurface : Color.mdOnSurface.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(
                color: configuration.isPressed ? Color.mdShadow.opacity(0.15) : Color.mdShadow,
                radius: configuration.isPressed ? 1 : 3,
                x: 0,
                y: configuration.isPressed ? 1 : 2
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/// Text button style following Material Design 3
struct TextButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .foregroundStyle(isEnabled ? Color.mdPrimary : Color.mdOnSurface.opacity(0.38))
            .background(
                configuration.isPressed ?
                    Color.mdPrimary.opacity(0.08) :
                    Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Button Style Extensions

extension ButtonStyle where Self == FilledButtonStyle {
    static var mdFilled: FilledButtonStyle {
        FilledButtonStyle()
    }
}

extension ButtonStyle where Self == FilledTonalButtonStyle {
    static var mdFilledTonal: FilledTonalButtonStyle {
        FilledTonalButtonStyle()
    }
}

extension ButtonStyle where Self == OutlinedButtonStyle {
    static var mdOutlined: OutlinedButtonStyle {
        OutlinedButtonStyle()
    }
}

extension ButtonStyle where Self == ElevatedButtonStyle {
    static var mdElevated: ElevatedButtonStyle {
        ElevatedButtonStyle()
    }
}

extension ButtonStyle where Self == TextButtonStyle {
    static var mdText: TextButtonStyle {
        TextButtonStyle()
    }
}

// MARK: - Preview

#Preview("Material Button Styles") {
    VStack(spacing: 16) {
        Text("Material Design 3 Button Styles")
            .font(.mdHeadlineSmall)
            .padding(.top)

        Button {
            print("Filled button tapped")
        } label: {
            HStack {
                Image(systemName: "play.fill")
                Text("Filled Button")
            }
            .font(.mdLabelLarge)
        }
        .buttonStyle(.mdFilled)

        Button {
            print("Filled tonal button tapped")
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Filled Tonal")
            }
            .font(.mdLabelLarge)
        }
        .buttonStyle(.mdFilledTonal)

        Button {
            print("Elevated button tapped")
        } label: {
            HStack {
                Image(systemName: "star.fill")
                Text("Elevated Button")
            }
            .font(.mdLabelLarge)
        }
        .buttonStyle(.mdElevated)

        Button {
            print("Outlined button tapped")
        } label: {
            HStack {
                Image(systemName: "heart")
                Text("Outlined Button")
            }
            .font(.mdLabelLarge)
        }
        .buttonStyle(.mdOutlined)

        Button {
            print("Text button tapped")
        } label: {
            Text("Text Button")
                .font(.mdLabelLarge)
        }
        .buttonStyle(.mdText)

        Text("Disabled States")
            .font(.mdTitleMedium)
            .padding(.top)

        Button {
            print("This won't print")
        } label: {
            Text("Disabled Filled")
                .font(.mdLabelLarge)
        }
        .buttonStyle(.mdFilled)
        .disabled(true)

        Button {
            print("This won't print")
        } label: {
            Text("Disabled Outlined")
                .font(.mdLabelLarge)
        }
        .buttonStyle(.mdOutlined)
        .disabled(true)
    }
    .padding()
    .background(Color.mdBackground)
}
