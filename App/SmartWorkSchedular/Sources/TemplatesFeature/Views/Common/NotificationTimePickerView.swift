import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftUI

@ViewAction(for: NotificationTimePicker.self)
public struct NotificationTimePickerView: View {
    public init(store: StoreOf<NotificationTimePicker>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<NotificationTimePicker>
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(#localized("Alert"))
                .font(.customHeadline)
                .padding(.vertical, 16)
            
            ForEach(NotificationTimeOption.allCases) { option in
                Button {
                    send(.optionSelected(option))
                } label: {
                    HStack {
                        Text(option.title)
                        
                        Spacer()
                        
                        if store.selectedOptions == option {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(Color.accent)
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
        .foregroundStyle(Color.text)
    }
}

#Preview {
    NotificationTimePickerView(
        store: .init(
            initialState: .init(),
            reducer: NotificationTimePicker.init
        )
    )
}
