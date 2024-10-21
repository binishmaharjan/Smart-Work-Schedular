import Foundation

public enum DisplayMode: String, RawRepresentable, CaseIterable, Identifiable {
    case month
    case week
    case day
    
    public var id: Self { self }
    
    public var name: String { rawValue.capitalized }
}
