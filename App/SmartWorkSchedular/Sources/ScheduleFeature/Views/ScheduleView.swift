import SwiftUI
import ComposableArchitecture

public struct ScheduleView: View {
    public init(store: StoreOf<Schedule>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Schedule>
    
    public var body: some View {
        Text("Schedule View")
    }
}

#Preview {
    ScheduleView(
        store: .init(
            initialState: .init(),
            reducer: Schedule.init
        )
    )
}
