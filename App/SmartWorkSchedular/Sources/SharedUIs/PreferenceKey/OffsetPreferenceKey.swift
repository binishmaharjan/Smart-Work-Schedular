import SwiftUI

public struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = 0
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
