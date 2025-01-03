import ComposableArchitecture
import NavigationBarFeature
import SharedUIs
import SwiftUI

public struct TemplatesView: View {
    public init(store: StoreOf<Templates>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<Templates>
    
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Templates View")
                    .font(.customTitle)
                    .foregroundStyle(Color.text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 50) // Takes space for navigation bar
            .padding(.top, 8)
            .background(Color.background)
            .overlay(navigationBar)
        }
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
}

#Preview {
    TemplatesView(
        store: .init(
            initialState: .init(),
            reducer: Templates.init
        )
    )
}
