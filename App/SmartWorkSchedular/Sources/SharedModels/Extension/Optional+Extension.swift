import Foundation

extension Optional where Wrapped == String {
    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
            
        case _:
            return ""
        }
    }
}

extension Optional where Wrapped: Collection {
    func unwrap(or wrapped: Wrapped) -> Wrapped {
        guard let self else { return wrapped }
        return self
    }
}

extension Optional where Wrapped == Int {
    func unwrap(or wrapped: Wrapped) -> Wrapped {
        guard let self else { return wrapped }
        return self
    }
}

extension Optional where Wrapped == Bool {
    func unwrap(or wrapped: Wrapped) -> Wrapped {
        guard let self else { return wrapped }
        return self
    }
}
