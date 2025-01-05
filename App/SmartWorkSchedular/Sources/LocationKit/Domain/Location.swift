import CoreLocation
import Foundation

/// Wrapper object for search location
public struct Location: Equatable, Identifiable, Hashable {
    public var id: String { title }
    /// Location name
    public var title: String
    /// location address
    public var subTitle: String
}
