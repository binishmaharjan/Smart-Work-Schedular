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
                    Button {
                        send(.locationSelected(location))
                    } label: {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.customHeadline)
                                .foregroundStyle(Color.accent)
                            
                            VStack(alignment: .leading) {
                                Text(location.title)
                                    .font(.customBody)
                                    .foregroundStyle(Color.text)
                                
                                Text(location.subTitle)
                                    .font(.customFootnote)
                                    .foregroundStyle(Color.subText)
                            }
                            .hSpacing(.leading)
                        }
                    }
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
