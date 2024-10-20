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
}
