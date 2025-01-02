import ComposableArchitecture
import SwiftUI

@ViewAction(for: TaskTimeline.self)
public struct TaskTimelineView: View {
    public init(store: StoreOf<TaskTimeline>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<TaskTimeline>
    
    public var body: some View {
        Text("Task Detail")
    }
}

#Preview {
    TaskTimelineView(
        store: .init(
            initialState: .init(),
            reducer: TaskTimeline.init
        )
    )
}
