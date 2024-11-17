import CalendarKit
import SharedUIs
import SwiftUI

struct MonthItemView: View {
    init(originDay: Day, day: Day) {
        self.originDay = originDay
        self.day = day
    }
    
    private var originDay: Day
    private var day: Day
    
    var body: some View {
        VStack {
            hSeparator()
            
            Text(day.formatted(.calendarDay))
                .font(.customCaption)
                .foregroundStyle(day.isInSameMonth(as: originDay) ? #color("text_color") : #color("sub_text_color"))
            
            Spacer()
        }
    }
}
