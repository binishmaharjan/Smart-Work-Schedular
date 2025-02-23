import SwiftUI

public struct SelectionModifier: ViewModifier {
    public let shouldShow: Bool
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                shouldShow ? Circle().stroke(Color.text, lineWidth: 2) : nil
            }
    }
}

extension View {
    public func showSelectionIndicator(when shouldShow: Bool) -> some View {
        self.modifier(SelectionModifier(shouldShow: shouldShow))
    }
}
