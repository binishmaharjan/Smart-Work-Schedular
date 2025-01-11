import SwiftUI

// MARK: Predefined Colors
//extension Color {
//    /// Light: #FFFFFF, Dark: #000000 (Prev: 161621)
//    public static let background = #color("background")
//    /// Light: #EEEEEE, Dark: #EEEEEE
//    public static let subBackground = #color("sub_background")
//    /// Light: #F4C33E, Dark: #F4C33E
//    public static let accent = #color("accent_color")
//    /// Light: #B5B5B5, Dark: #F5F5F5
//    public static let separator = #color("separator")
//    /// Light: #8E8E93, Dark: #A6A6AB
//    public static let subText = #color("sub_text_color")
//    /// public static var sharedUIs: Bundle { .module }
//    /// Light: #1E1E2D, Dark: #FEFEFF
//    public static let text = #color("text_color")
//    /// Light: #EFEFF1, Dark: #121212
//    public static let searchBar = #color("search_bar")
//}

// MARK: Hex Code
extension Color {
    /// Initializes a new UIColor instance from a hex string
    public init(hex: String) {
        let uiColor = UIColor(hex: hex)
        self.init(uiColor: uiColor)
    }

    /// Returns a hex string representation of the UIColor instance
    public func toHexString(includeAlpha: Bool = false) -> HexCode? {
        UIColor(self).toHexString(includeAlpha: includeAlpha)
    }
}
