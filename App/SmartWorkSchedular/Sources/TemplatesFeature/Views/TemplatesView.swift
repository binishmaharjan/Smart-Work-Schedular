import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct TemplatesView: View {
    public init(store: StoreOf<Templates>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Templates>
    
    public var body: some View {
        Text("Templates View")
            .font(.customTitle)
            .foregroundStyle(#color("text_color"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(#color("background"))
    }
}

#Preview {
    TemplatesView(
        store: .init(
            initialState: .init(),
            reducer: Templates.init
        )
    )
}
