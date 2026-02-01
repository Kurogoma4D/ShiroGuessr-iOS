import SwiftUI

/// View for displaying and interacting with a gradient map
struct GradientMapView: View {
    /// The gradient map to display
    let gradientMap: GradientMap

    /// Optional pin placed by the user
    var userPin: Pin?

    /// Optional target pin to show after submission
    var targetPin: Pin?

    /// Whether pin placement is enabled
    var isInteractionEnabled: Bool = true

    /// Callback when user taps to place a pin
    var onPinPlacement: ((MapCoordinate) -> Void)?

    // MARK: - Constants

    private let mapSize: CGFloat = 300

    // MARK: - Body

    var body: some View {
        ZStack {
            // Gradient map canvas
            Canvas { context, size in
                drawGradientMap(context: context, size: size)
            }
            .frame(width: mapSize, height: mapSize)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture { location in
                handleTap(at: location)
            }

            // User pin
            if let userPin {
                pinMarker(
                    coordinate: userPin.coordinate,
                    color: .blue,
                    systemImage: "mappin.circle.fill"
                )
            }

            // Target pin (shown after submission)
            if let targetPin {
                pinMarker(
                    coordinate: targetPin.coordinate,
                    color: .red,
                    systemImage: "target"
                )
            }
        }
        .frame(width: mapSize, height: mapSize)
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

    // MARK: - Pin Marker

    /// Creates a pin marker view
    private func pinMarker(
        coordinate: MapCoordinate,
        color: Color,
        systemImage: String
    ) -> some View {
        let pinX = CGFloat(coordinate.x) * mapSize
        let pinY = CGFloat(coordinate.y) * mapSize

        // Use circle instead of mappin to avoid offset issues
        return Circle()
            .fill(color)
            .frame(width: 16, height: 16)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .overlay(
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
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
        targetPin: targetPin
    )
    .padding()
}
