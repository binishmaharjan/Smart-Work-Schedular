import CoreLocation
import Foundation

/// Wrapper object for search location
public struct Location: Equatable, Identifiable {
    public var id = UUID()
    /// Location name
    public var title: String
    /// location address
    public var subTitle: String
}
