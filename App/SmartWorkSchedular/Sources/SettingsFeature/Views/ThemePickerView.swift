import ComposableArchitecture
import SharedUIs
import SwiftUI

public struct ThemePickerView: View {
    public init(store: StoreOf<ThemePicker>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ThemePicker>
    
    public var body: some View {
        VStack {
            List {
                ForEach(store.modes) { mode in
                    LabeledContent(mode.name) {
                        Button {
                            store.send(.modeSelected(mode))
                        } label: {
                            if store.currentMode == mode {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(#localized("Appearance"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    ThemePickerView(
        store: .init(
            initialState: .init(),
            reducer: ThemePicker.init
        )
    )
}
