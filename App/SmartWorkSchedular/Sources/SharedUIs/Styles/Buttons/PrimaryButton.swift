import SwiftUI

public struct PrimaryButton: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.customHeadline)
            .frame(width: 176, height: 44)
            .foregroundColor(Color.text)
            .background(Color.accent)
            .opacity(1)
            .cornerRadius(10)
    }
}

extension View {
    public func primaryButton() -> some View {
        modifier(PrimaryButton())
    }
}
