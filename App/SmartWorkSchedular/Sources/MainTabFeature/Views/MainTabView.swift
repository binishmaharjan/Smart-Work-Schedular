import SwiftUI
import ComposableArchitecture

public struct MainTabView: View {
    public init(store: StoreOf<MainTab>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MainTab>
    
    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    MainTabView(
        store: .init(
            initialState: .init(),
            reducer: MainTab.init
        )
    )
}
