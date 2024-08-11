import SwiftUI
import ComposableArchitecture

public struct TutorialView: View {
    public init(store: StoreOf<Tutorial>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Tutorial>
    
    public var body: some View {
        Text("Tutorial View")
    }
}

#Preview {
    TutorialView(
        store: .init(
            initialState: .init(),
            reducer: Tutorial.init
        )
    )
}
