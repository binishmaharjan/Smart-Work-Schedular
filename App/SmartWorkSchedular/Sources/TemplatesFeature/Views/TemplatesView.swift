import ComposableArchitecture
import SharedUIs
import SwiftUI

public struct TemplatesView: View {
    public init(store: StoreOf<Templates>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Templates>
    
    public var body: some View {
        Text("Templates View")
            .font(.customTitle)
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
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
