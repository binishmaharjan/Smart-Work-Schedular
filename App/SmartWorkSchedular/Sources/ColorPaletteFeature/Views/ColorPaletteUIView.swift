import UIKit

/// Color Picker For Choosing a Color
public final class ColorPaletteUIView: UIView {
    // MARK: Init
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private let saturationExponentTop: Float = 1.0
    private let saturationExponentBottom: Float = 1.0
    
    private var mainPaletteRect: CGRect = .zero
    public var onColorDidChange: ((_ color: UIColor) -> Void)?
    
    public var elementSize: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Override
    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        mainPaletteRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        
        // Main Palette
        for yPoint in stride(from: CGFloat.zero, to: mainPaletteRect.height, by: elementSize) {
            var saturation = yPoint < mainPaletteRect.height / 2.0 ?
            CGFloat(2 * yPoint) / mainPaletteRect.height :
            2.0 * CGFloat(mainPaletteRect.height - yPoint) / mainPaletteRect.height
            
            saturation = CGFloat(
                powf(
                    Float(saturation),
                    yPoint < mainPaletteRect.height / 2.0 ?
                        saturationExponentTop :
                        saturationExponentBottom
                )
            )
            
            let brightness = yPoint < mainPaletteRect.height / 2.0 ?
            CGFloat(1.0) :
            2.0 * CGFloat(mainPaletteRect.height - yPoint) / mainPaletteRect.height
            
            for xPoint in stride(from: CGFloat.zero, to: mainPaletteRect.width, by: elementSize) {
                guard let context = context else { fatalError("No Context") }
                
                let hue = xPoint / mainPaletteRect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: xPoint, y: yPoint + mainPaletteRect.origin.y, width: elementSize, height: elementSize))
            }
        }
    }
    
    // MARK: Methods
    /// Initial setup for the color view
    private func setup() {
        clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = .greatestFiniteMagnitude
        addGestureRecognizer(touchGesture)
    }
    
    @objc private func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.onColorDidChange?(color)
    }
    
    /// Get the uiColor at the point of user touch
    ///
    /// - Parameter point: location of the user touch
    /// - Return: UIColor at the location
    private func getColorAtPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
