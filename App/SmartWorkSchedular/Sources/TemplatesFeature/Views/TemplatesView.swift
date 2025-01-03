import ComposableArchitecture
import NavigationBarFeature
import SharedUIs
import SwiftUI

@ViewAction(for: Templates.self)
public struct TemplatesView: View {
    public init(store: StoreOf<Templates>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<Templates>
    
    public var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $store.selectedKind) {
                    ForEach(Templates.Kind.allCases) { kind in
                        Text(kind.title)
                            .tag(kind)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                TabView(selection: $store.selectedKind) {
                    ShiftListView(store: store.scope(state: \.shiftList, action: \.shiftList))
                        .tag(Templates.Kind.shift)
                    
                    RotationListView(store: store.scope(state: \.rotationList, action: \.rotationList))
                        .tag(Templates.Kind.rotation)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 50) // Takes space for navigation bar
            .padding(.top, 8)
            .background(Color.background)
            .overlay(navigationBar)
        }
        .onAppear { send(.onAppear) }
        .sheet(
            item: $store.scope(state: \.destination?.shiftEditor, action: \.destination.shiftEditor),
            content: shiftEditor(store:)
        )
    }
}

// MARK: Views
extension TemplatesView {
    @ViewBuilder
    private var navigationBar: some View {
        NavigationBarView(
            store: store.scope(state: \.navigationBar, action: \.navigationBar)
        )
    }
    
    @ViewBuilder
    private func shiftEditor(store: StoreOf<ShiftEditor>) -> some View {
        ShiftEditorView(store: store)
    }
}

#Preview {
    TemplatesView(
        store: .init(
            initialState: .init(),
            reducer: Templates.init
        )
    )
}
