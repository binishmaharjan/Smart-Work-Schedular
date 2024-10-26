import ComposableArchitecture
import SwiftUI

public struct LaunchView: View {
    public init(store: StoreOf<Launch>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Launch>
    
    public var body: some View {
        Text("Launch View")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    LaunchView(
        store: .init(
            initialState: .init(),
            reducer: Launch.init
        )
    )
}
