import ComposableArchitecture
import SwiftUI

@ViewAction(for: EntriesTimeline.self)
public struct EntriesTimelineView: View {
    public init(store: StoreOf<EntriesTimeline>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<EntriesTimeline>
    
    public var body: some View {
        Text("Task Detail")
    }
}

#Preview {
    EntriesTimelineView(
        store: .init(
            initialState: .init(),
            reducer: EntriesTimeline.init
        )
    )
}
