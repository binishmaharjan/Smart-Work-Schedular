import ComposableArchitecture
import SharedUIs
import SwiftUI

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
                    
                    Text(store.subTitle ?? "")
                        .font(.customHeadline)
                        .foregroundStyle(#color("accent_color"))
                }
                
                Spacer()

                if let firstTrailingItem = store.firstTrailingItem {
                    Button {
                        store.send(.firstTrailingItemTapped)
                    } label: {
                        Image(systemName: firstTrailingItem)
                            .navigationItemStyle()
                    }
                }
                
                if let secondTrailingItem = store.secondTrailingItem {
                    Button {
                        store.send(.secondTrailingItemTapped)
                    } label: {
                        Image(systemName: secondTrailingItem)
                            .navigationItemStyle()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .toolbar(.hidden)
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
