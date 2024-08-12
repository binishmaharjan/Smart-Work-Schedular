import SwiftUI
import ComposableArchitecture
import SharedUIs
import CalendarFeature

public struct ScheduleView: View {
    public init(store: StoreOf<Schedule>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Schedule>
    
    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button(#localized("Prev")) {
                    store.send(.previousButtonPressed)
                }
                .buttonStyle(.borderedProminent)
                
                Text(#localized("Some Text"))
                    .frame(maxWidth: .infinity)
                
                Button(#localized("Next")) {
                    store.send(.nextButtonPressed)
                }
                .buttonStyle(.borderedProminent)
            }
            
            ScrollView {
                ForEach(Array(store.month.enumerated()), id: \.element.id) { index, week in
//                ForEach(store.month) { week in
                    Text("Week: \(index + 1)")
                    ForEach(week.days) { day in
                        Text("\(day.formatted(.dateTest))")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(#color("background"))
        .onAppear { store.send(.onAppear) }
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
