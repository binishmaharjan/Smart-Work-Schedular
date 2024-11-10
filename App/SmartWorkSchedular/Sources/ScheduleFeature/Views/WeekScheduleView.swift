import ComposableArchitecture
import SwiftUI

public struct WeekScheduleView: View {
    public init(store: StoreOf<WeekSchedule>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<WeekSchedule>
    
    public var body: some View {
        Text("Week Schedule View")
    }
}

#Preview {
    WeekScheduleView(
        store: .init(
            initialState: .init(),
            reducer: WeekSchedule.init
        )
    )
}
