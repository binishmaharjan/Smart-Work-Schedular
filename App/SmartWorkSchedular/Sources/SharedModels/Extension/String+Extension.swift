import Foundation
import UIKit

public enum Process {
    case encode
    case decode
}

extension String {
    public var trimmed: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var isValidPassword: Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    public var isBackspace: Bool {
        let ansic = cString(using: .utf8)
        return strcmp(ansic, "\\b") == -92
    }

    public func removingWhitespaces() -> String {
        components(separatedBy: .whitespaces).joined()
    }

    public func trimmed(at limit: Int) -> String {
        if endIndex.utf16Offset(in: self) > limit {
            var trimmedString = self
            var index = 0
            
            // Use endIndex.encodeOffset of caption instead of count of caption
            // because server validates data by counting memories, not counting letters
            while trimmedString.endIndex.utf16Offset(in: self) > limit {
                trimmedString = String(prefix(limit - index))
                index += 1
            }
            return trimmedString
        }
        return self
    }

    public func trailed(with length: Int) -> String {
        if length < 0 {
            return ""
        }
        return String(suffix(length))
    }

    public func base64(_ method: Process) -> String? {
        switch method {
        case .encode:
            return data(using: .utf8)?.base64EncodedString()
            
        case .decode:
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }

    public func urlEncode() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    public func validPath() -> String? {
        guard isNotEmpty else { return nil }
        if lowercased().hasPrefix("https://") || lowercased().hasPrefix("http://") {
            return self
        }
        return "https://" + self
    }

    public func validURL() -> URL? {
        var validURL: URL?
        guard let path = validPath(), path.isNotEmpty else { return nil }
        if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
            validURL = url
        } else if let urlEncode = path.urlEncode(), let url = URL(string: urlEncode), UIApplication.shared.canOpenURL(url) {
            validURL = url
        }
        return validURL
    }

    public func contentHeight(contentWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: contentWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }

    public func contentHeight(contentWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let constraintRect = CGSize(width: contentWidth, height: .greatestFiniteMagnitude)
        let boundingBox = attributedString.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return boundingBox.height
    }

    public func contentWidth(font: UIFont) -> CGFloat {
        let size = (self as String).size(withAttributes: [.font: font])
        return size.width
    }

    public func stringFromHTML() -> NSAttributedString? {
        do {
            guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return nil }
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
        }
        return nil
    }
}

extension String {
    public func encoded(withAllowedCharacters characterSet: CharacterSet = .alphanumerics) -> String {
        if let encoded: String = addingPercentEncoding(withAllowedCharacters: characterSet) {
            return encoded
        }
        return self
    }

    public func replace(regex: String, with char: String) -> String {
        do {
            var result = self
            let regex = try NSRegularExpression(pattern: regex)
            let matches = regex.matches(
                in: result,
                range: NSRange(result.startIndex..., in: result)
            )
            let replaceStrings = matches.map { match -> String in
                guard let range = Range(match.range, in: result) else {
                    return ""
                }
                return String(result[range])
            }
            for replaceString in replaceStrings {
                if let range = result.range(of: replaceString) {
                    result.replaceSubrange(range, with: char)
                }
            }
            return result
        } catch {
            return ""
        }
    }

    /// Keep "\n" to prevent break line
    /// Keep "\n" characters by replace "\n" by "\\\\n"
    /// - Returns: The string contain "\n" and not break line
    public func notBreakLine() -> String {
        self.replacingOccurrences(of: "\n", with: "\\\\n")
    }
}

// MARK: - Get content string with width

extension String {
    public func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }

    public func stringWithWidth(text: String, font: UIFont, contentTextSize: CGFloat, needToCutSize width: CGFloat, replaceCharacter: String) -> String {
        let contentTextSize = text.sizeOfString(usingFont: font).width
        var neddToCutString = replaceCharacter + text
        var cuttedTextSize = contentTextSize
        while cuttedTextSize > width {
            neddToCutString.removeLast()
            cuttedTextSize = neddToCutString.sizeOfString(usingFont: font).width
        }
        neddToCutString.removeFirst(replaceCharacter.count)
        neddToCutString += replaceCharacter
        return neddToCutString
    }
}

// MARK: - Get height with string and font
extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}

extension String {
    public func substring(from: Int?, upTo: Int?) -> String {
        guard let start = from, start < self.count,
            let end = upTo, end >= 0,
            end - start >= 0
            else {
                return ""
        }

        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }

        let endIndex: String.Index
        if let end = upTo, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }

        return String(self[startIndex ..< endIndex])
    }

    public func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }

        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }

        return self.substring(from: from, upTo: end)
    }

    public func substring(length: Int, upTo: Int?) -> String {
        guard let end = upTo, end > 0, length > 0 else {
            return ""
        }

        let start: Int
        if let end = upTo, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }

        return self.substring(from: start, upTo: upTo)
    }

    public func nsRanges(of string: String, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> [NSRange] {
        var start = range?.lowerBound ?? startIndex
        let end = range?.upperBound ?? endIndex
        var ranges: [NSRange] = []
        while start < end, let range = self.range(of: string, options: options, range: start..<end, locale: locale ?? .current) {
            ranges.append(.init(range, in: self))
            start = range.upperBound
        }
        return ranges
    }
}

extension String {
    /// Initializes an NSURL object with a provided URL string. (read-only)
    public var url: URL? {
        URL(string: self)
    }

    /// The host, conforming to RFC 1808. (read-only)
    public var host: String {
        if let url = url, let host = url.host {
            return host
        }
        return ""
    }
}

extension String {
    public typealias Byte = UInt8
    
    public var hexaToBytes: [Byte] {
        var start = startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in   // use flatMap for older Swift versions
            let end = index(after: start)
            defer { start = index(after: end) }
            return Byte(self[start...end], radix: 16)
        }
    }
}

// MARK: - Validated String
extension String {
    public var decimalDigits: [String] {
        let decimalDigits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let arr = decimalDigits.map {
            String($0)
        }
        return arr
    }
    
    public func validateWithRegex(_ regex: String) -> Bool {
        let validateName = NSPredicate(format: "SELF MATCHES %@", regex)
        return validateName.evaluate(with: self)
    }
}

// MARK: - Code created by @Bien Le Convert base64 string
extension String {
    public func validBase64Decoded() -> String {
        var base64String = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        let remainder = self.count % 4
        if remainder > 0 {
            base64String = self.padding(
                toLength: self.count + 4 - remainder,
                withPad: "=",
                startingAt: 0
            )
        }
        guard Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) != nil else {
            return ""
        }
        return base64String
    }

    /// isEscape: true if escape, false is unescape
    public func escapeOrUnEscapeChar(isEscape: Bool) -> String {
        var newStr = self
        var specialCharDic: [(String, String)] = [
            ("&", "&amp;"),
            ("'", "&apos;"),
            ("\"", "&quot;"),
            ("<", "&lt;"),
            (">", "&gt;")
        ]
        if !isEscape {
            specialCharDic = specialCharDic.reversed()
        }
        for (unEscapedChar, escapedChar) in specialCharDic {
            if isEscape {
                newStr = newStr.replacingOccurrences(of: unEscapedChar, with: escapedChar)
            } else {
                newStr = newStr.replacingOccurrences(of: escapedChar, with: unEscapedChar)
            }
        }
        return newStr
    }
}

extension String {
    public var xmlNewLineDecodeString: String {
        self.replacingOccurrences(of: "\\n", with: "\n")
    }
}

extension String {
    public func isValidPhoneNumber(with regex: String) -> Bool {
        if self.isBackspace {
            return true
        }
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
