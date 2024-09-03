import SwiftUI
import ComposableArchitecture

public struct SettingsView: View {
    public init(store: StoreOf<Settings>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Settings>
    
    public var body: some View {
        Text("Settings View")
        Button {
            store.send(.closeButtonTapped)
        } label: {
            Text("Close")
        }
    }
}

#Preview {
    SettingsView(
        store: .init(
            initialState: .init(),
            reducer: Settings.init
        )
    )
}
