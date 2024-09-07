import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct StartWeekOnView: View {
    public init(store: StoreOf<StartWeekOn>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<StartWeekOn>
    
    public var body: some View {
        VStack {
            List {
                ForEach(store.weekdays) { weekday in
                    LabeledContent(weekday.title) {
                        Button {
                            store.send(.selected(weekday))
                        } label: {
                            if store.startOfWeekday == weekday {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(#localized("Start Week On"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    StartWeekOnView(
        store: .init(
            initialState: .init(),
            reducer: StartWeekOn.init
        )
    )
}
