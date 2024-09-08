import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct AppearanceView: View {
    public init(store: StoreOf<Appearance>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Appearance>
    
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
    AppearanceView(
        store: .init(
            initialState: .init(),
            reducer: Appearance.init
        )
    )
}
