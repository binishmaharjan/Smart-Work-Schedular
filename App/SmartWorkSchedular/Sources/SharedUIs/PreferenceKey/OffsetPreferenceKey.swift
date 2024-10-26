import SwiftUI

/// Preference Key to get current offset in the scroll view
public struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = 0
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
