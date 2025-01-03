import SwiftUI

/// Supporting: Picker Item view With no clear background
private struct PickerItemViewIndicator: UIViewRepresentable {
    var result: () -> Void
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let pickerView = view.pickerView {
                if pickerView.subviews.count > 1 {
                    // second view contains the background for the UIPicker view
                    pickerView.subviews[1].backgroundColor = .clear
                }
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct PickerItemView<Content: View, Selection: Hashable>: View {
    @Binding var selection: Selection
    @ViewBuilder var content: Content
    @State private var isIndicatorBackgroundRemoved = false
    
    var body: some View {
        Picker("", selection: $selection) {
            if !isIndicatorBackgroundRemoved {
                PickerItemViewIndicator {
                    isIndicatorBackgroundRemoved = true
                }
            } else {
                content
            }
        }
        .pickerStyle(.wheel)
    }
}

// MARK: UIView + PickerView
extension UIView {
    fileprivate var pickerView: UIPickerView? {
        guard let view = superview as? UIPickerView else {
            return superview?.pickerView
        }
        
        return view
    }
}
