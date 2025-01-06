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
                    
                    iconRow
                }
                
                Section {
                    Toggle(#localized("All Day"), isOn: $store.isAllDay)

                    startsDateRow
                    
                    endsDateRow
                }
                
                Section {
                    breakTimeRow
                }
                
                Section {
                    notificationTimeRow
                }
                
                Section {
                    locationRow
                }
                
                Section {
                    TextField(#localized("Memo"), text: $store.memo, axis: .vertical)
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
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            send(.cancelButtonTapped)
        } label: {
            Text(#localized("Cancel"))
                .font(.customBody)
        }
    }
    
    @ViewBuilder
    private var saveButton: some View {
        Button {
            send(.saveButtonTapped)
        } label: {
            Text(#localized("Save"))
                .font(.customHeadline)
        }
    }
    
    @ViewBuilder
    private var iconRow: some View {
        LabeledContent(#localized("Icon")) {
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)

                Button {
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                }
            }
        }
    }
    
    @ViewBuilder
    private var startsDateRow: some View {
        LabeledContent(#localized("Starts")) {
            Button {
                send(.startDateButtonTapped)
            } label: {
                Text(store.startDate.description)
            }
        }
        .foregroundStyle(Color.text)
    }
    
    @ViewBuilder
    private var endsDateRow: some View {
        LabeledContent(#localized("Ends")) {
            Button {
                send(.endDateButtonTapped)
            } label: {
                Text(store.endDate.description)
            }
        }
        .foregroundStyle(Color.text)
    }
    
    @ViewBuilder
    private var breakTimeRow: some View {
        if store.breakTime.isEmpty {
            LabeledContent(#localized("Break")) {
                Button {
                    send(.breakButtonTapped)
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
            }
        } else {
            LabeledContent(#localized("Break")) {
                HStack {
                    Text(store.breakTime.timeDescription)
                        .foregroundStyle(Color.subText)
                    
                    Button {
                        send(.breakClearButtonTapped)
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var notificationTimeRow: some View {
        LabeledContent(#localized("Alert")) {
            Button {
                send(.alertButtonTapped)
            } label: {
                Text(store.notificationTime.title)
            }
        }
        .foregroundStyle(Color.text)
    }
    
    @ViewBuilder
    private var locationRow: some View {
        if store.location.isEmpty {
            Button {
                send(.locationButtonTapped)
            } label: {
                Text(#localized("Location"))
            }
            .foregroundStyle(Color.text)
        } else {
            HStack {
                Button {
                    send(.locationButtonTapped)
                } label: {
                    Text(store.location)
                }
                .foregroundStyle(Color.text)
                // make button style borderless, so that both button action are not invoked
                .buttonStyle(.borderless)
                
                Spacer()
                
                Button {
                    send(.locationClearButtonTapped)
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                // make button style borderless, so that both button action are not invoked
                .buttonStyle(.borderless)
            }
        }
    }
    
    @ViewBuilder
    private func timePicker(store: StoreOf<TimePicker>) -> some View {
        TimePickerView(store: store)
            .sheetWithContentHeight($sheetHeight)
    }
    
    @ViewBuilder
    private func notificationTime(store: StoreOf<NotificationTimePicker>) -> some View {
        NotificationTimePickerView(store: store)
            .sheetWithContentHeight($sheetHeight)
    }
    
    @ViewBuilder
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
