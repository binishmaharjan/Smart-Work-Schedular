import SwiftUI
import ComposableArchitecture

public struct TemplatesView: View {
    public init(store: StoreOf<Templates>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Templates>
    
    public var body: some View {
        Text("Hello World")
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
