import ComposableArchitecture
import SwiftUI

@ViewAction(for: RotationList.self)
public struct RotationListView: View {
    public init(store: StoreOf<RotationList>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<RotationList>
    
    public var body: some View {
        Text("Rotation List View")
    }
}

#Preview {
    RotationListView(
        store: .init(
            initialState: .init(),
            reducer: RotationList.init
        )
    )
}
