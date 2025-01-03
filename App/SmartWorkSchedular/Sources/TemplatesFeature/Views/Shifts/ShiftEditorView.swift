import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: ShiftEditor.self)
public struct ShiftEditorView: View {
    public init(store: StoreOf<ShiftEditor>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<ShiftEditor>
    
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
                            print("add break")
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
}

#Preview {
    ShiftEditorView(
        store: .init(
            initialState: .init(),
            reducer: ShiftEditor.init
        )
    )
}
