import Foundation

/// Representation of color asset
struct ColorAsset {
    var originalName: String
    var camelCaseName: String
    
    var toStaticProperty: String {
        """
        public static let \(camelCaseName) = Color(\"\(originalName)\", bundle: .module)
        """
    }
}
