import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct EarningsView: View {
    public init(store: StoreOf<Earnings>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Earnings>
    
    public var body: some View {
        Text("Earnings View")
            .font(.customTitle)
            .foregroundStyle(#color("text_color"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(#color("background"))
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
