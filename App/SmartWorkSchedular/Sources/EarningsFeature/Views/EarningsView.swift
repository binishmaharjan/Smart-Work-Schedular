import SwiftUI
import ComposableArchitecture

public struct EarningsView: View {
    public init(store: StoreOf<Earnings>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Earnings>
    
    public var body: some View {
        Text("Earnings View")
    }
}

#Preview {
    EarningsView(
        store: .init(
            initialState: .init(),
            reducer: Earnings.init
        )
    )
}
