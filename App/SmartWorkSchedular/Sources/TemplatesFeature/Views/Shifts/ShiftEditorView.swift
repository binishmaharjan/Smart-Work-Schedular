import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: ShiftEditor.self)
public struct ShiftEditorView: View {
    public init(store: StoreOf<ShiftEditor>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<ShiftEditor>
    @State private var sheetHeight: CGFloat = .zero
    
    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(#localized("Title"), text: $store.title, axis: .horizontal)
                    
                    Text(#localized("Icon"))
                }
                
                Section {
                    Toggle(#localized("All Day"), isOn: $store.isAllDay)

                    LabeledContent(#localized("Starts")) {
                        Button {
                            send(.startDateButtonTapped)
                        } label: {
                            Text(store.startDate.description)
                        }
                    }
                    .foregroundStyle(Color.text)
                    
                    LabeledContent(#localized("Ends")) {
                        Button {
                            send(.endDateButtonTapped)
                        } label: {
                            Text(store.endDate.description)
                        }
                    }
                    .foregroundStyle(Color.text)
                }
                
                Section {
                    LabeledContent(#localized("Break")) {
                        Button {
                            send(.addBreakButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                Section {
                    LabeledContent(#localized("Alert")) {
                        Button {
                            send(.alertButtonTapped)
                        } label: {
                            Text(store.notificationTime.title)
                        }
                    }
                    .foregroundStyle(Color.text)
                }
                
                Section {
                    Button {
                        send(.locationButtonTapped)
                    } label: {
                        Text(#localized("Location"))
                    }
                    .foregroundStyle(Color.text)
                }
                
                Section {
                    TextField(#localized("Memo"), text: .constant(""), axis: .vertical)
                        .frame(height: 100, alignment: .top)
                }
            }
            .font(.customBody)
            .navigationTitle(store.kind.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .sheet(
            item: $store.scope(state: \.destination?.breakTimePicker, action: \.destination.breakTimePicker),
            content: timePicker(store:)
        )
        .sheet(
            item: $store.scope(state: \.destination?.startDatePicker, action: \.destination.startDatePicker),
            content: timePicker(store:)
        )
        .sheet(
            item: $store.scope(state: \.destination?.endDatePicker, action: \.destination.endDatePicker),
            content: timePicker(store:)
        )
        .sheet(
            item: $store.scope(state: \.destination?.notificationTime, action: \.destination.notificationTime),
            content: notificationTime(store:)
        )
        .sheet(
            item: $store.scope(state: \.destination?.searchLocation, action: \.destination.searchLocation),
            content: searchLocation(store:)
        )
    }
}

// MARK: Views
extension ShiftEditorView {
    private var cancelButton: some View {
        Button {
            send(.cancelButtonTapped)
        } label: {
            Text(#localized("Cancel"))
                .font(.customBody)
        }
    }
    
    private var saveButton: some View {
        Button {
            send(.saveButtonTapped)
        } label: {
            Text(#localized("Save"))
                .font(.customHeadline)
        }
    }
    
    private func timePicker(store: StoreOf<TimePicker>) -> some View {
        TimePickerView(store: store)
            .sheetWithContentHeight($sheetHeight)
    }
    
    private func notificationTime(store: StoreOf<NotificationTimePicker>) -> some View {
        NotificationTimePickerView(store: store)
            .sheetWithContentHeight($sheetHeight)
    }
    
    private func searchLocation(store: StoreOf<SearchLocation>) -> some View {
        SearchLocationView(store: store)
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
    }
}

#Preview {
    ShiftEditorView(
        store: .init(
            initialState: .init(),
            reducer: ShiftEditor.init
        )
    )
}
