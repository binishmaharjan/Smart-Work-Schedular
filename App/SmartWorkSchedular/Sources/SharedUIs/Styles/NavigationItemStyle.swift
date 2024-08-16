import SwiftUI

public struct NavigationItemStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.customHeadline)
            .frame(width: 36, height: 36)
            .foregroundColor(#color("text_color"))
            .background(#color("accent_color"))
            .opacity(0.6)
            .cornerRadius(10)
    }
}


extension View {
    func navigationItemStyle() -> some View {
        self.modifier(NavigationItemStyle())
    }
}
