import ComposableArchitecture
import SwiftUI

@ViewAction(for: IconPicker.self)
public struct IconPickerView: View {
    public init(store: StoreOf<IconPicker>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<IconPicker>
    
    public var body: some View {
        Text("Icon Picker View")
    }
}

#Preview {
    IconPickerView(
        store: .init(
            initialState: .init(),
            reducer: IconPicker.init
        )
    )
}
