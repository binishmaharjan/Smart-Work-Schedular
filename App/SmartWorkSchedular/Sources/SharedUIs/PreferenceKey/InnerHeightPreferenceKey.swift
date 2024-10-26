import SwiftUI

/// Preference Key to get height of the inner content
public struct InnerHeightPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = .zero
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
