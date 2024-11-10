import ComposableArchitecture
import SwiftUI

public struct DayScheduleView: View {
    public init(store: StoreOf<DaySchedule>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<DaySchedule>
    
    public var body: some View {
        Text("Day Schedule View")
    }
}

#Preview {
    DayScheduleView(
        store: .init(
            initialState: .init(),
            reducer: DaySchedule.init
        )
    )
}
