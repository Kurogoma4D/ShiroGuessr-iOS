import Foundation

/// Map coordinate with normalized values (0-1)
struct MapCoordinate: Codable, Equatable {
    /// Normalized x coordinate (0-1)
    let x: Double
    /// Normalized y coordinate (0-1)
    let y: Double
}
