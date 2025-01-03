import ComposableArchitecture
import SwiftUI

@ViewAction(for: ShiftEditor.self)
public struct ShiftEditorView: View {
    public init(store: StoreOf<ShiftEditor>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<ShiftEditor>
    
    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    ShiftEditorView(
        store: .init(
            initialState: .init(),
            reducer: ShiftEditor.init
        )
    )
}
