import ComposableArchitecture
import NavigationBarFeature
import SharedUIs
import SwiftUI

public struct SettingsView: View {
    public init(store: StoreOf<Settings>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Settings>
    
    public var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        ForEach(0..<2) { index in
                            if index == 0 {
                                Button {
                                    store.send(.startWeekOnMenuTapped)
                                } label: {
                                    Text("Start Week On")
                                }
                            } else {
                                Button {
                                    store.send(.appearanceTapped)
                                } label: {
                                    Text("Appearance")
                                }
                            }
                        }
                    } header: {
                        Text("Preferences")
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.vertical)
                .padding(.top, 50) // Takes space for navigation bar
                .navigationDestination(
                    item: $store.scope(state: \.destination?.startWeekOn, action: \.destination.startWeekOn),
                    destination: StartWeekOnView.init(store:)
                )
                .navigationDestination(
                    item: $store.scope(state: \.destination?.appearance, action: \.destination.appearance),
                    destination: ThemePickerView.init(store:)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(navigationBar)
        }
    }
}

// MARK: Views
extension SettingsView {
    @ViewBuilder
    private var navigationBar: some View {
        NavigationBarView(
            store: store.scope(state: \.navigationBar, action: \.navigationBar)
        )
    }
}

#Preview {
    SettingsView(
        store: .init(
            initialState: .init(),
            reducer: Settings.init
        )
    )
}

// List {
//    ForEach(store.groupedAnniversariesList, id: \.self) { groupedAnniversaries in
//        Section {
//            ForEach(groupedAnniversaries.anniversaries, id: \.self) { anniversary in
//                Button {
//                    store.send(.anniversaryTapped(anniversary))
//                } label: {
//                    Item(anniversary: anniversary, editMode: store.editMode)
//                }
//            }
//            .onDelete { indexSet in
//                guard let index = indexSet.first else {
//                    return
//                }
//                let anniversary = groupedAnniversaries.anniversaries[index]
//                store.send(.onDeleteAnniversary(anniversary))
//            }
//            
//        } header: {
//            Text(groupedAnniversaries.key)
//                .font(.title2)
//                .foregroundStyle(#color("#000000"))
//                .padding(.leading, -16)
//        }
//        .textCase(nil)
//    }
// }
