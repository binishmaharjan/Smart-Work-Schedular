import SwiftUI
import ComposableArchitecture

@ViewAction(for: ColorPalette.self)
public struct ColorPaletteView: View {
    public init(store: StoreOf<ColorPalette>) {
        self.store = store
    }
    
    private let store: StoreOf<ColorPalette>
    
    public var body: some View {
        ColorPaletteRepresentable { color in
            if let hexCode = color.toHexString() {
                send(.colorSelected(hexCode))
            }
        }
        .border(Color.gray)
    }
}

#Preview {
    ColorPaletteView(
        store: .init(
            initialState: .init(),
            reducer: ColorPalette.init
        )
    )
}


