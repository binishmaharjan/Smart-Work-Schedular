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

                    DatePicker(
                        #localized("Starts"),
                        selection: .constant(.now),
                        displayedComponents: [.hourAndMinute]
                    )
                    DatePicker(
                        #localized("Ends"),
                        selection: .constant(.now),
                        displayedComponents: [.hourAndMinute]
                    )
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
                    Text(#localized("Alert"))
                }
                
                Section {
                    Text(#localized("Location"))
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
        .sheet(
            item: $store.scope(state: \.destination?.timePicker, action: \.destination.timePicker),
            content: breakTimePicker(store:)
        )
    }
}

// MARK: Views
extension ShiftEditorView {
    private var cancelButton: some View {
        Button {
            print("cancel pressed")
        } label: {
            Text(#localized("Cancel"))
                .font(.customBody)
        }
    }
    
    private var saveButton: some View {
        Button {
            print("save pressed")
        } label: {
            Text(#localized("Save"))
                .font(.customHeadline)
        }
    }
    
    private func breakTimePicker(store: StoreOf<TimePicker>) -> some View {
        TimePickerView(store: store)
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: InnerHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
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
