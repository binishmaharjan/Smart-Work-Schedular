import Foundation

public enum AppScheme: String, RawRepresentable, Identifiable, CaseIterable {
    case system
    case light
    case dark
    
    public var id: Self { self }
    
    public var name: String { rawValue.capitalized }
}
