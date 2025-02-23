import Foundation

public enum NumberFormatStyle {
    public struct TwoDigit: FormatStyle {
        public func format(_ value: Int) -> String {
            String(format: "%02d", value)
        }
    }
}

extension FormatStyle where Self == NumberFormatStyle.TwoDigit {
    /// Format Style for two digit number
    public static var twoDigit: NumberFormatStyle.TwoDigit { .init() }
}
