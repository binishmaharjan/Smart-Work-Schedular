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
                ForEach(IconPreset.Image.allCases) { image in
                    Button {
                        send(.imageTapped(image))
                    } label: {
                        Image(systemName: image.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .foregroundStyle(Color.background)
                            .background(Circle().fill(Color.subText))
                    }
                    .buttonStyle(.borderless)
                }
                ForEach(IconPreset.Color.allCases) { color in
                    Button {
                        send(.colorTapped(color))
                    } label: {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .foregroundStyle(Color(hex: color.rawValue))
                    }
                    .buttonStyle(.borderless)
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
