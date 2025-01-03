import ComposableArchitecture
import SwiftUI

@ViewAction(for: ShiftList.self)
public struct ShiftListView: View {
    public init(store: StoreOf<ShiftList>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<ShiftList>
    
    public var body: some View {
        Text("Shift List View")
    }
}

#Preview {
    ShiftListView(
        store: .init(
            initialState: .init(),
            reducer: ShiftList.init
        )
    )
}
