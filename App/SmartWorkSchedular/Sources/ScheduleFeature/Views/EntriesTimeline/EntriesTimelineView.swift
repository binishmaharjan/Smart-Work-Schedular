import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftUI

@ViewAction(for: EntriesTimeline.self)
public struct EntriesTimelineView: View {
    public init(store: StoreOf<EntriesTimeline>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<EntriesTimeline>
    
    @State private var entries: [Entry] = [
        Entry(
            id: UUID(), 
            title: "Family Mart 1",
            icon: "sun.max.fill",
            isAllDay: false, 
            startDate: "0900",
            endDate: "1700",
            entryType: .shift, 
            creationDate: .now
        ),
        Entry(
            id: UUID(),
            title: "Family Mart 2",
            icon: "moon.fill",
            isAllDay: false,
            startDate: "0900",
            endDate: "1700",
            entryType: .shift,
            creationDate: .now
        ),
        Entry(
            id: UUID(),
            title: "Family Mart 3",
            icon: "highlighter",
            isAllDay: false,
            startDate: "0900",
            endDate: "1700",
            entryType: .shift,
            creationDate: .now
        ),
        Entry(
            id: UUID(),
            title: "Family Mart 4",
            icon: "highlighter",
            isAllDay: false,
            startDate: "0900",
            endDate: "1700",
            entryType: .shift,
            creationDate: .now
        ),
        Entry(
            id: UUID(),
            title: "Family Mart 5",
            icon: "highlighter",
            isAllDay: false,
            startDate: "0900",
            endDate: "1700",
            entryType: .shift,
            creationDate: .now
        ),
    ].sorted { $0.creationDate < $1.creationDate }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                entriesList
            }
            .hSpacing(.center)
            .vSpacing(.center)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 20)
    }
}

// MARK: Views
extension EntriesTimelineView {
    @ViewBuilder
    private var entriesList: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($entries) { $entry in
                EntryView(entry: $entry)
                    .background(alignment: .leading) {
                        timelineIndicator
                    }
            }
        }
        .padding([.vertical, .leading])
    }
    
    @ViewBuilder
    private var timelineIndicator: some View {
        Rectangle()
            .frame(width: 1)
            .offset(x: 8)
            .padding(.bottom, -35)
    }
}

#Preview {
    EntriesTimelineView(
        store: .init(
            initialState: .init(),
            reducer: EntriesTimeline.init
        )
    )
}
