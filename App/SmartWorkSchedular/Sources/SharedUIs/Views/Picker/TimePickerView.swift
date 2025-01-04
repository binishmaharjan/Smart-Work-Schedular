import ComposableArchitecture
import Foundation
import SharedModels
import SwiftUI
import UIKit

@Reducer
public struct TimePicker {
    @ObservableState
    public struct State: Equatable {
        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
        
        var hour: Int
        var minute: Int
    }
    
    public enum Action: ViewAction, BindableAction {
        @CasePathable
        public enum Delegate: Equatable {
            case saveTime(HourAndMinute)
        }

        public enum View {
            case saveButtonPressed
        }
        
        case view(View)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.saveButtonPressed):
                return .run { [state] send in
                    await send(.delegate(.saveTime(HourAndMinute(hour: state.hour, minute: state.minute))))
                    await dismiss()
                }
                
            case .view, .binding, .delegate:
                return .none
            }
        }
    }
}

@ViewAction(for: TimePicker.self)
public struct TimePickerView: View {
    public init(store: StoreOf<TimePicker>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<TimePicker>
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("Break")
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
            initialState: .init(hour: 12, minute: 0),
            reducer: TimePicker.init
        )
    )
}
