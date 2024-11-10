import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: CalendarMode.self)
public struct CalendarModeView: View {
    public init(store: StoreOf<CalendarMode>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<CalendarMode>
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("Select Mode")
                .font(.customHeadline)
                .padding(.vertical, 16)
            
            ForEach(store.displayModeList) { mode in
                Button {
                    send(.onDisplayModeSelected(mode))
                } label: {
                    HStack {
                        Label(mode.name, systemImage: mode.image)
                        
                        Spacer()
                        
                        if store.displayMode == mode {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(#color("accent_color"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 44)
            }
            .padding(.horizontal, 16)
            .font(.customHeadline)
        }
        .padding(.bottom, 16)
        .foregroundStyle(#color("text_color"))
    }
}

#Preview {
    CalendarModeView(
        store: .init(
            initialState: .init(),
            reducer: CalendarMode.init
        )
    )
}

