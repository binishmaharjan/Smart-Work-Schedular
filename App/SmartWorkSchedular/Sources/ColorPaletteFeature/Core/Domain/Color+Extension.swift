import SwiftUI

extension Color {
    /// Initializes a new UIColor instance from a hex string
    init(hex: String) {
        let uiColor = UIColor(hex: hex)
        self.init(uiColor: uiColor)
    }

    /// Returns a hex string representation of the UIColor instance
    func toHexString(includeAlpha: Bool = false) -> HexCode? {
        UIColor(self).toHexString(includeAlpha: includeAlpha)
    }
}
