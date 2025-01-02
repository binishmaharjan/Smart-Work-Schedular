import SharedModels
import SharedUIs
import SwiftUI

struct EntryView: View {
    @Binding var entry: Entry

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(Color.background)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(
                    Color.accent.shadow(.drop(color: Color.text.opacity(0.1), radius: 3)),
                    in: .circle
                )
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.customSubheadline)
                    .foregroundStyle(Color.text)
                
                Label(entry.creationDate.formatted(.monthAndYear), systemImage: "clock")
                    .font(.customCaption)
                    .foregroundStyle(Color.text)
            }
            .padding(15)
            .hSpacing(.leading)
            .background(Color.subBackground, in: RoundedRectangle(cornerRadius: 8))
            .offset(y: -8)
        }
    }
}
