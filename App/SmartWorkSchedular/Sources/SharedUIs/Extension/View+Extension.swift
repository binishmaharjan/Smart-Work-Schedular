import SwiftUI

extension View {
    /// horizontal spacer
    @ViewBuilder
    public func hSpacing(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    /// vertical spacer
    @ViewBuilder
    public func vSpacing(_ alignment: Alignment) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// horizontal separator
    @ViewBuilder
    public func hSeparator() -> some View {
        Rectangle()
            .fill(Color.subText.opacity(0.5))
            .frame(height: 1)
    }
    
    /// vertical separator
    @ViewBuilder
    public func vSeparator() -> some View {
        Rectangle()
            .fill(Color.subText.opacity(0.5))
            .frame(width: 1)
    }
    
    /// today's indicator
    @ViewBuilder
    public func todayIndicator(color: Color = Color.accent) -> some View {
        Circle()
            .fill(color)
            .frame(width: 5, height: 5)
    }
}
