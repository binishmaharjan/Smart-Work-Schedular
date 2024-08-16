import SwiftUI

public struct NavigationBar: View {
    public init(title: String) {
        self.title = title
    }
    
    public var title: String
    
    public var body: some View {
        ZStack {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("My Work Schedule")
                        .font(.customSubheadline)
                        .foregroundStyle(#color("text_color"))
                    
                    Text("August")
                        .font(.customHeadline)
                        .foregroundStyle(#color("accent_color"))
                }
                
                Spacer()

                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .navigationItemStyle()
                        
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .navigationItemStyle()
                        
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
}


#Preview {
    NavigationBar(title: "August")
}
