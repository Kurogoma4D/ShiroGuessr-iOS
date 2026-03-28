import SwiftUI

/// View for displaying and interacting with a gradient map
/// Wrapped in a gallery-style frame with dark border and subtle shadow.
struct GradientMapView: View {
    /// The gradient map to display
    let gradientMap: GradientMap

    /// Optional pin placed by the user
    var userPin: Pin?

    /// Optional target pin to show after submission
    var targetPin: Pin?

    /// Whether to show target pin with pop-in animation
    var showTargetPinAnimated: Bool = false

    /// Progress of dashed line drawing (0-1)
    var lineDrawProgress: CGFloat = 0.0

    /// The size (width and height) of the square map canvas
    var mapSize: CGFloat = 300

    /// Whether pin placement is enabled
    var isInteractionEnabled: Bool = true

    /// Callback when user taps to place a pin
    var onPinPlacement: ((MapCoordinate) -> Void)?

    /// Frame border width for the gallery-style frame
    private let frameBorderWidth: CGFloat = 3

    // MARK: - Body

    var body: some View {
        ZStack {
            // Gradient map canvas
            Canvas { context, size in
                drawGradientMap(context: context, size: size)
            }
            .frame(width: mapSize, height: mapSize)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture { location in
                handleTap(at: location)
            }

            // Dashed line between user pin and target pin (gold color)
            if let userPin, let targetPin, lineDrawProgress > 0 {
                DashedLinePath(
                    from: CGPoint(x: userPin.coordinate.x, y: userPin.coordinate.y),
                    to: CGPoint(x: targetPin.coordinate.x, y: targetPin.coordinate.y)
                )
                .trim(from: 0, to: lineDrawProgress)
                .stroke(
                    Color.mdPrimary.opacity(0.8),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 6])
                )
                .animation(.easeOut(duration: 0.42), value: lineDrawProgress)
            }

            // User pin (gold accent with drop animation)
            if let userPin {
                AnimatedUserPin(
                    coordinate: userPin.coordinate,
                    mapSize: mapSize
                )
            }

            // Target pin (shown after submission)
            if let targetPin {
                if showTargetPinAnimated {
                    AnimatedTargetPin(coordinate: targetPin.coordinate, mapSize: mapSize)
                } else {
                    targetPinMarker(coordinate: targetPin.coordinate)
                }
            }
        }
        .frame(width: mapSize, height: mapSize)
        // Gallery-style frame: dark border
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.mdSurfaceVariant, lineWidth: frameBorderWidth)
        )
        // Subtle outer shadow
        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
    }

    // MARK: - Drawing Methods

    /// Draws the gradient map using Canvas
    private func drawGradientMap(context: GraphicsContext, size: CGSize) {
        let width = gradientMap.width
        let height = gradientMap.height
        let pixelWidth = size.width / CGFloat(width)
        let pixelHeight = size.height / CGFloat(height)

        // Draw each pixel with bilinear interpolation
        for y in 0..<height {
            for x in 0..<width {
                let normalizedX = Double(x) / Double(width - 1)
                let normalizedY = Double(y) / Double(height - 1)

                let color = getInterpolatedColor(x: normalizedX, y: normalizedY)

                let rect = CGRect(
                    x: CGFloat(x) * pixelWidth,
                    y: CGFloat(y) * pixelHeight,
                    width: pixelWidth,
                    height: pixelHeight
                )

                context.fill(
                    Path(rect),
                    with: .color(color)
                )
            }
        }
    }

    /// Gets interpolated color at normalized coordinates
    private func getInterpolatedColor(x: Double, y: Double) -> Color {
        let topLeft = gradientMap.cornerColors[0]
        let topRight = gradientMap.cornerColors[1]
        let bottomLeft = gradientMap.cornerColors[2]
        let bottomRight = gradientMap.cornerColors[3]

        // Interpolate top edge
        let topR = interpolate(from: Double(topLeft.r), to: Double(topRight.r), t: x)
        let topG = interpolate(from: Double(topLeft.g), to: Double(topRight.g), t: x)
        let topB = interpolate(from: Double(topLeft.b), to: Double(topRight.b), t: x)

        // Interpolate bottom edge
        let bottomR = interpolate(from: Double(bottomLeft.r), to: Double(bottomRight.r), t: x)
        let bottomG = interpolate(from: Double(bottomLeft.g), to: Double(bottomRight.g), t: x)
        let bottomB = interpolate(from: Double(bottomLeft.b), to: Double(bottomRight.b), t: x)

        // Interpolate between top and bottom
        let r = interpolate(from: topR, to: bottomR, t: y)
        let g = interpolate(from: topG, to: bottomG, t: y)
        let b = interpolate(from: topB, to: bottomB, t: y)

        return Color(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0
        )
    }

    /// Linear interpolation helper
    private func interpolate(from: Double, to: Double, t: Double) -> Double {
        from + (to - from) * t
    }

    // MARK: - Target Pin (static, non-animated)

    /// Creates a target pin marker (white circle + red outline)
    private func targetPinMarker(coordinate: MapCoordinate) -> some View {
        let pinX = CGFloat(coordinate.x) * mapSize
        let pinY = CGFloat(coordinate.y) * mapSize

        return Circle()
            .fill(Color.white)
            .frame(width: 18, height: 18)
            .overlay(
                Circle()
                    .stroke(Color.mdError, lineWidth: 2.5)
            )
            .overlay(
                Circle()
                    .fill(Color.mdError)
                    .frame(width: 6, height: 6)
            )
            .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
            .position(x: pinX, y: pinY)
    }

    // MARK: - Interaction Handlers

    /// Handles tap gesture for pin placement
    /// Location is in Canvas's local coordinate space (0 to mapSize)
    private func handleTap(at location: CGPoint) {
        guard isInteractionEnabled, onPinPlacement != nil else { return }

        // Normalize to 0-1 range and clamp
        let normalizedX = max(0, min(1, location.x / mapSize))
        let normalizedY = max(0, min(1, location.y / mapSize))

        let coordinate = MapCoordinate(x: normalizedX, y: normalizedY)
        onPinPlacement?(coordinate)
    }
}

// MARK: - Animated User Pin

/// User pin with gold accent and ease-out drop animation.
/// Replays the drop animation each time the pin is repositioned via its id.
private struct AnimatedUserPin: View {
    let coordinate: MapCoordinate
    let mapSize: CGFloat

    @State private var dropOffset: CGFloat = -20
    @State private var opacity: CGFloat = 0.0

    var body: some View {
        let pinX = CGFloat(coordinate.x) * mapSize
        let pinY = CGFloat(coordinate.y) * mapSize

        Circle()
            .fill(Color.mdPrimary)
            .frame(width: 18, height: 18)
            .overlay(
                Circle()
                    .stroke(Color.mdPrimary.opacity(0.6), lineWidth: 3)
            )
            .overlay(
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 6, height: 6)
            )
            .shadow(color: Color.mdPrimary.opacity(0.4), radius: 4, x: 0, y: 2)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            .offset(y: dropOffset)
            .opacity(opacity)
            .position(x: pinX, y: pinY)
            .onAppear {
                // Reset for animation replay
                dropOffset = -20
                opacity = 0.0
                withAnimation(.easeOut(duration: 0.15)) {
                    dropOffset = 0
                    opacity = 1.0
                }
            }
            // Use coordinate as id to replay animation on each placement
            .id("\(coordinate.x)-\(coordinate.y)")
    }
}

// MARK: - Animated Target Pin

/// Target pin (white circle + red outline) with pop-in + pulse animation on result reveal
private struct AnimatedTargetPin: View {
    let coordinate: MapCoordinate
    let mapSize: CGFloat

    @State private var scale: CGFloat = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: CGFloat = 0.6

    var body: some View {
        let pinX = CGFloat(coordinate.x) * mapSize
        let pinY = CGFloat(coordinate.y) * mapSize

        ZStack {
            // Pulse ring (expands outward and fades)
            Circle()
                .stroke(Color.mdError.opacity(pulseOpacity), lineWidth: 2)
                .frame(width: 18 * pulseScale, height: 18 * pulseScale)
                .scaleEffect(scale > 0.5 ? 1.0 : 0.0)

            // Main pin: white circle + red outline
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .stroke(Color.mdError, lineWidth: 2.5)
                )
                .overlay(
                    Circle()
                        .fill(Color.mdError)
                        .frame(width: 6, height: 6)
                )
                .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
        }
        .scaleEffect(scale)
        .position(x: pinX, y: pinY)
        .onAppear {
            // Pop-in with spring
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
            }

            // Start pulse animation after pop-in completes
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatCount(3, autoreverses: true)
                .delay(0.4)
            ) {
                pulseScale = 1.8
                pulseOpacity = 0.0
            }
        }
    }
}

// MARK: - Previews

#Preview("Empty Map") {
    let map = GradientMap(
        width: 50,
        height: 50,
        cornerColors: [
            RGBColor(r: 245, g: 250, b: 255),
            RGBColor(r: 255, g: 245, b: 250),
            RGBColor(r: 250, g: 255, b: 245),
            RGBColor(r: 255, g: 255, b: 245)
        ]
    )

    return GradientMapView(gradientMap: map)
        .padding()
        .background(Color.mdBackground)
}

#Preview("With Pins") {
    let map = GradientMap(
        width: 50,
        height: 50,
        cornerColors: [
            RGBColor(r: 245, g: 250, b: 255),
            RGBColor(r: 255, g: 245, b: 250),
            RGBColor(r: 250, g: 255, b: 245),
            RGBColor(r: 255, g: 255, b: 245)
        ]
    )

    let userPin = Pin(
        coordinate: MapCoordinate(x: 0.3, y: 0.7),
        color: RGBColor(r: 250, g: 252, b: 248)
    )

    let targetPin = Pin(
        coordinate: MapCoordinate(x: 0.8, y: 0.2),
        color: RGBColor(r: 253, g: 248, b: 251)
    )

    return GradientMapView(
        gradientMap: map,
        userPin: userPin,
        targetPin: targetPin,
        showTargetPinAnimated: true,
        lineDrawProgress: 1.0
    )
    .padding()
    .background(Color.mdBackground)
}
