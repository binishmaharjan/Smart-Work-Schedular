import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: SearchLocation.self)
public struct SearchLocationView: View {
    public init(store: StoreOf<SearchLocation>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<SearchLocation>
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(#localized("Location"))
                .font(.customHeadline)
                .padding(.vertical, 16)
            
            SearchBar(text: $store.searchText)
            
            List {
                ForEach(store.locations) { location in
                    VStack(alignment: .leading) {
                        Text(location.title)
                            .font(.customBody)
                        
                        Text(location.subTitle)
                            .font(.customFootnote)
                    }
                    .hSpacing(.leading)
                }
            }
            .listStyle(.plain)
        }
        .vSpacing(.top)
        .onAppear { send(.onAppear) }
        .onChange(of: store.searchText) { _, newValue in
            send(.searchTextChanged(newValue))
        }
    }
}

#Preview {
    SearchLocationView(
        store: .init(
            initialState: .init(),
            reducer: SearchLocation.init
        )
    )
}
