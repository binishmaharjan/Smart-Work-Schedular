import Foundation

public enum Weekday: String, RawRepresentable, CaseIterable, Identifiable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    public var id: Self { self }
    
    public var name: String { rawValue.capitalized }
}
