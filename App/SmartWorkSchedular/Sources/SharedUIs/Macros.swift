import Foundation
import SwiftUI

@freestanding(expression)
public macro localized(_ key: LocalizedStringResource) -> String = #externalMacro(module: "AppMacros", type: "Localized")

@freestanding(expression)
public macro color(_ key: String) -> Color = #externalMacro(module: "AppMacros", type: "Color")

@freestanding(expression)
public macro image(_ key: String) -> Image = #externalMacro(module: "AppMacros", type: "Image")

@attached(peer, names: arbitrary)
public macro sharedPeer(_ rawValueType: Any.Type) = #externalMacro(module: "AppMacros", type: "SharedPeer")

@attached(accessor)
public macro sharedAccessor() = #externalMacro(module: "AppMacros", type: "SharedAccessor")
