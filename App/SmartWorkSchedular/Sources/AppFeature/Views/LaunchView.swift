import SwiftUI
import ComposableArchitecture

public struct LaunchView: View {
    public init(store: StoreOf<Launch>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Launch>
    
    public var body: some View {
        Text("Launch View")
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
