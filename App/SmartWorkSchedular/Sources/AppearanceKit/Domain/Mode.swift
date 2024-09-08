import Foundation

public enum AppearanceMode: String, RawRepresentable, Identifiable, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    public var id: Self { self }
    
    public var name: String { rawValue.capitalized }
}
