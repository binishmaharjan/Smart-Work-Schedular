import Foundation
import SwiftUI
import LoggerClient
import Dependencies

public enum CustomFont: String, CaseIterable {
    case light = "Nunito-Light"
    case regular = "Nunito-Medium"
    case semiBold = "Nunito-SemiBold"
    case bold = "Nunito-Bold"
}

extension Font.TextStyle {
    public var size: CGFloat {
        switch self {
        case .largeTitle: return 34.0
        case .title: return 28.0
        case .title2: return 22.0
        case .title3: return 20.0
        case .headline: return 17.0
        case .subheadline: return 15.0
        case .body: return 17.0
        case .callout: return 16.0
        case .footnote: return 13.0
        case .caption: return 12.0
        case .caption2: return 11.0
        @unknown default: return 8.0
        }
    }
}

extension Font {
    private static func custom(_ font: CustomFont, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
    
    /// FontSize: 34.0, Weight: Bold
    public static let customLargeTitle = custom(.bold, relativeTo: .largeTitle)
    /// FontSize: 28.0, Weight: SemiBold
    public static let customTitle = custom(.semiBold, relativeTo: .title)
    /// FontSize: 22.0, Weight: SemiBold
    public static let customTitle2 = custom(.semiBold, relativeTo: .title2)
    /// FontSize: 20.0, Weight: SemiBold
    public static let customTitle3 = custom(.semiBold, relativeTo: .title3)
    /// FontSize: 17.0, Weight: SemiBold
    public static let customHeadline = custom(.semiBold, relativeTo: .headline)
    /// FontSize: 17.0, Weight: Regular
    public static let customBody = custom(.regular, relativeTo: .body)
    /// FontSize: 16.0, Weight: Light
    public static let customCallout = custom(.light, relativeTo: .callout)
    /// FontSize: 15.0, Weight: Regular
    public static let customSubheadline = custom(.regular, relativeTo: .subheadline)
    /// FontSize: 13.0, Weight: Light
    public static let customFootnote = custom(.light, relativeTo: .footnote)
    /// FontSize: 12.0, Weight: Regular
    public static let customCaption = custom(.regular, relativeTo: .caption)
    /// FontSize: 11.0, Weight: Light
    public static let customCaption2 = custom(.light, relativeTo: .caption2)
}

// MARK: Custom Font Manager
public struct CustomFontManager {
    public static func registerFonts() {
        @Dependency(\.loggerClient) var logger
        logger.debug("Register Custom Fonts")
        
        CustomFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
