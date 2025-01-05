import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    public var isNotEmpty: Bool {
        return !isEmpty
    }

    public var pairs: [SubSequence] {
        var startIndex = self.startIndex
        let count = self.count
        let n = count / 4 + count % 4
        return (0..<n).map { _ in
            if let endIndex = index(startIndex, offsetBy: 4, limitedBy: self.endIndex) {
                defer { startIndex = endIndex }
                return self[startIndex..<endIndex]
            }
            defer { startIndex = self.endIndex }
            return self[startIndex..<self.endIndex]
        }
    }
}

extension Array {
    public func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}

extension Array {
    public func islastElement(index: Int) -> Bool {
        index == endIndex - 1
    }

    public func isFirstElement(index: Int) -> Bool {
        index == 0
    }
}
