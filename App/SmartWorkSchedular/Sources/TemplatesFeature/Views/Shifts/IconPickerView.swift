import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: IconPicker.self)
public struct IconPickerView: View {
    public init(store: StoreOf<IconPicker>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<IconPicker>
    @State private var sheetHeight: CGFloat = 0
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(IconPreset.allCases) { iconPreset in
                    Image(systemName: iconPreset.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .foregroundStyle(Color.background)
                        .background(Circle().fill(Color.subText))
                }
            }
        }
    }
}

#Preview {
    IconPickerView(
        store: .init(
            initialState: .init(),
            reducer: IconPicker.init
        )
    )
}
