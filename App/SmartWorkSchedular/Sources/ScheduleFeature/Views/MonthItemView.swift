import SwiftUI
import CalendarKit
import SharedUIs

struct MonthItemView: View {
    init(day: Day) {
        self.day = day
    }
    
    private var day: Day
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(#color("sub_text_color").opacity(0.5))
                .frame(height: 1)

            Text(day.formatted(.dateTime.day()))
                .font(.customCaption)
                .foregroundStyle(day.isInThisMonth ? #color("text_color") : #color("sub_text_color"))
            
            Spacer()
        }
    }
}

#Preview {
    MonthItemView(
        day: .init(date: .now)
    )
}
