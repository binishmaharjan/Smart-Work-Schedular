import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct NavigationBarView: View {
    public init(store: StoreOf<NavigationBar>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<NavigationBar>
    
    public var body: some View {
        ZStack {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(store.title)
                        .font(.customSubheadline)
                        .foregroundStyle(#color("text_color"))
                    
                    Text("August")
                        .font(.customHeadline)
                        .foregroundStyle(#color("accent_color"))
                }
                
                Spacer()

                Button {
                    store.send(.firstTrailingItemTapped)
                } label: {
                    Image(systemName: "plus")
                        .navigationItemStyle()
                        
                }
                
                Button {
                    store.send(.secondTrailingItemTapped)
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .navigationItemStyle()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
}

#Preview {
    NavigationBarView(
        store: .init(
            initialState: .init(title: "My Work Schedule"),
            reducer: NavigationBar.init
        )
    )
}
