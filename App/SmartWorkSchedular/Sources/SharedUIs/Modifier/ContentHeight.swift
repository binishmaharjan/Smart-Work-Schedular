import SwiftUI

struct ContentHeightSheet: ViewModifier {
    @Binding var sheetHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: InnerHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
            .presentationDragIndicator(.visible)
    }
}

extension View {
    public func sheetWithContentHeight(_ height: Binding<CGFloat>) -> some View {
        self.modifier(ContentHeightSheet(sheetHeight: height))
    }
}
