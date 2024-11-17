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
            .fill(#color("sub_text_color").opacity(0.5))
            .frame(height: 1)
    }
    
    /// vertical separator
    @ViewBuilder
    public func vSeparator() -> some View {
        Rectangle()
            .fill(#color("sub_text_color").opacity(0.5))
            .frame(width: 1)
    }
    
    /// today's indicator
    @ViewBuilder
    public func todayIndicator(color: Color = #color("accent_color")) -> some View {
        Circle()
            .fill(color)
            .frame(width: 5, height: 5)
    }
}
