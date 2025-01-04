import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftUI
import UIKit

@ViewAction(for: TimePicker.self)
public struct TimePickerView: View {
    public init(store: StoreOf<TimePicker>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<TimePicker>
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(store.title)
                .font(.customHeadline)
                .padding(.vertical, 16)
            
            HStack(spacing: 0) {
                pickerItem(#localized("hr"), 0...23, $store.hour)
                pickerItem(#localized("min"), 0...59, $store.minute)
            }
            // because each title width is 50, applying half of the offset
            // in opposite direction will position the picker in the center
            .offset(y: -25)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(height: 35)
                    .offset(y: -25)
            }
            
            okButton
        }
    }
}

// MARK: Views
extension TimePickerView {
    @ViewBuilder
    private var okButton: some View {
        Button {
            send(.saveButtonPressed)
        } label: {
            Text(#localized("Save"))
                .primaryButton()
                .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func pickerItem(_ title: String, _ range: ClosedRange<Int>, _ selection: Binding<Int>) -> some View {
        PickerItemView(selection: selection) {
            ForEach(range, id: \.self) { value in
                Text("\(value)")
                    .tag(value)
                    .frame(width: 35, alignment: .trailing)
            }
        }
        .overlay {
            Text(title)
                .font(.customCallout)
                .bold()
                .frame(width: 50, alignment: .leading)
                .lineLimit(1)
                .offset(x: 50)
        }
    }
}

#Preview {
    TimePickerView(
        store: .init(
            initialState: .init(title: "Break", hour: 12, minute: 0),
            reducer: TimePicker.init
        )
    )
}
