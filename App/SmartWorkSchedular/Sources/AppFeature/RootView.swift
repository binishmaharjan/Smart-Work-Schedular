import SwiftUI
import SharedUIs

public struct RootView: View {
    public init() { }
    
    public var body: some View {
        Text(#localized("Hello World"))
    }
}

#Preview {
    RootView()
}
