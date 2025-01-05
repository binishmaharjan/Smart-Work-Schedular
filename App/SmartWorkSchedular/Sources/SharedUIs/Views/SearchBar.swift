import SwiftUI

public struct SearchBar: View {
    public init(text: Binding<String>) {
        self._text = text
    }
    
    @Binding private var text: String
    
    public var body: some View {
        VStack {
            ZStack {
                // 背景
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 239 / 255, green: 239 / 255, blue: 241 / 255))
                    .frame(height: 36)
                
                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)
                    
                    // 虫眼鏡
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    // テキストフィールド
                    TextField("Search", text: $text)
                    
                    // 検索文字が空ではない場合は、クリアボタンを表示
                    if !text.isEmpty {
                        Button {
                            text.removeAll()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 6)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchBar(text: .constant("Placeholder"))
}

// MARK: Placeholder Color
extension View {
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, color: Color, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder()
                .opacity(shouldShow ? 1 : 0)
                .foregroundColor(color)
            self
        }
    }
}
