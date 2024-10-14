import SwiftUI
import CalendarKit
import SharedUIs

struct MonthItemView: View {
    init(originDay: Day, day: Day) {
        self.originDay = originDay
        self.day = day
    }
    
    private var originDay: Day
    private var day: Day
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(#color("sub_text_color").opacity(0.5))
                .frame(height: 1)

            Text(day.formatted(.dateTime.day()))
                .font(.customCaption)
                .foregroundStyle(day.isInSameMonth(as: originDay) ? #color("text_color") : #color("sub_text_color"))
            
            Spacer()
        }
    }
}

#Preview {
    MonthItemView(
        originDay: .init(date: .now), day: .init(date: .now)
    )
}
