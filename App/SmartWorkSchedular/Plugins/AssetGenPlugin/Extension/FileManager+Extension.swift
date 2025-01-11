import Foundation

extension FileManager {
    /// creates directory if it does not exist at path
    func createDirectoryIfNotExists(atPath path: String) throws {
        guard !fileExists(atPath: path) else { return }
        try createDirectory(atPath: path, withIntermediateDirectories: true)
    }
}

extension FileManager {
    /// returns all file name with extension color set
    func fetchColors(atPath path: String) throws -> [String] {
        try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(FileExtension.colorset.rawValue) }
            .compactMap { $0.components(separatedBy: ".").first }
    }
}
