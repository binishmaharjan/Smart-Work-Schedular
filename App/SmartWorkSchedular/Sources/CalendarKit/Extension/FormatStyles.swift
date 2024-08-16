import Foundation

// MARK: Date Identifier Format
public struct DateIdentifierFormat: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = false
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        return formatter.string(from: value.startOfDate)
    }
}

extension FormatStyle where Self == DateIdentifierFormat {
    public static var dateIdentifier: DateIdentifierFormat { .init() }
}

// MARK: Date Identifier Format
public struct DateTestFormat: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = false
        formatter.dateFormat = "EEEE, MMMM dd, yyy"
        return formatter.string(from: value.startOfDate)
    }
}

extension FormatStyle where Self == DateIdentifierFormat {
    public static var dateTest: DateIdentifierFormat { .init() }
}
