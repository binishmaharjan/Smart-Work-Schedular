import SwiftUI

public struct NavigationItemStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.customHeadline)
            .frame(width: 36, height: 36)
            .foregroundColor(Color.text)
            .background(Color.accent)
            .opacity(1)
            .cornerRadius(10)
    }
}

extension View {
    public func navigationItemStyle() -> some View {
        self.modifier(NavigationItemStyle())
    }
}
