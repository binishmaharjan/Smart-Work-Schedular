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
    
    // TODO: Temp
    var entries: [Entries] = [
        
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
    }
}

// MARK: Views
extension EntriesTimelineView {
    @ViewBuilder
    private var entriesList: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach(entries) { entry in
            }
        }
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


struct EntryView: View {
    var body: some View {
        Text("Entry View")
    }
}
