import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

struct MonthItemView: View {
    init(originDay: Day, day: Day) {
        self.originDay = originDay
        self.day = day
    }
    
    // Shared State
    @Shared(.mem_currentSelectedDay) var currentSelectedDay = Day(date: .now)
    
    private var originDay: Day
    private var day: Day
    
    private var textColor: Color {
        if day.isInSameMonth(as: originDay) && day.isSameDay(as: currentSelectedDay) {
            #color("background")
        } else if day.isInSameMonth(as: originDay) && !day.isSameDay(as: currentSelectedDay) {
            #color("text_color")
        } else {
            #color("sub_text_color")
        }
    }
    
    private var todayIndicatorColor: Color {
        if day.isSameDay(as: currentSelectedDay) {
            #color("background")
        } else {
            #color("accent_color")
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(day.formatted(.calendarDay))
                .font(.customCaption)
                .foregroundStyle(textColor)
                .padding(.top, 4)
            
            if day.isToday {
                todayIndicator(color: todayIndicatorColor)
            }
        } 
        .vSpacing(.top)
        .hSpacing(.center)
        .background {
            if day.isSameDay(as: currentSelectedDay) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(#color("accent_color"))
            }
        }
    }
}
