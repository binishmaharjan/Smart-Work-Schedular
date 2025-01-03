import ComposableArchitecture
import SharedUIs
import SwiftUI

public struct EarningsView: View {
    public init(store: StoreOf<Earnings>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Earnings>
    
    public var body: some View {
        Text("Earnings View")
            .font(.customTitle)
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
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
