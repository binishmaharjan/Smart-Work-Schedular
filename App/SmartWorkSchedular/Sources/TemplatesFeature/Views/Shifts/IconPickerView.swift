import ColorPaletteFeature
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
                iconList
                
                colorList
            }
        }
        .sheet(
            item: $store.scope(state: \.destination?.colorPalette, action: \.destination.colorPalette),
            content: colorPalette(store:)
        )
    }
}

// MARK: Views
extension IconPickerView {
    @ViewBuilder
    private var iconList: some View {
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
                    .showSelectionIndicator(when: store.selectedImage == image)
            }
            .buttonStyle(.borderless)
        }
    }
    
    private var colorList: some View {
        ForEach(IconPreset.Color.allCases) { color in
            Button {
                if color == .custom {
                    send(.showColorPalette)
                } else {
                    send(.colorTapped(color))
                }
            } label: {
                if color == .custom {
                    Image.icnColorWheel
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color(hex: color.rawValue))
                        .showSelectionIndicator(when: store.selectedColor == color)
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color(hex: color.rawValue))
                        .showSelectionIndicator(when: store.selectedColor == color)
                }
            }
            .buttonStyle(.borderless)
        }
    }
    
    @ViewBuilder
    private func colorPalette(store: StoreOf<ColorPalette>) -> some View {
        VStack(spacing: 0) {
            Text(#localized("Color Picker"))
                .font(.customHeadline)
                .padding(.vertical, 16)
            
            ColorPaletteView(store: store)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .vSpacing(.top)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
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
