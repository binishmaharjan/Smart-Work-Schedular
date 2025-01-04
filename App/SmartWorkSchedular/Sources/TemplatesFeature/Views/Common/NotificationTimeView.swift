import ComposableArchitecture
import SwiftUI

@ViewAction(for: NotificationTime.self)
public struct NotificationTimeView: View {
    public init(store: StoreOf<NotificationTime>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<NotificationTime>
    
    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    NotificationTimeView(
        store: .init(
            initialState: .init(),
            reducer: NotificationTime.init
        )
    )
}
