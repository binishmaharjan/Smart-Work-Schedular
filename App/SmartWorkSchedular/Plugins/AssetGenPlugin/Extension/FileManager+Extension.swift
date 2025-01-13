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
    func fetchColors(atPath path: String) throws -> [ColorAsset] {
        try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(FileExtension.colorset.rawValue) }
            .compactMap { $0.components(separatedBy: ".").first }
            .map { ColorAsset(originalName: $0, camelCaseName: $0.toCamelCase) }
    }
    
    /// returns all file name with extension image set
    func fetchImages(atPath path: String) throws -> [ImageAsset] {
        let imagesName: [String?] = try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasSuffix(FileExtension.imageset.rawValue) }
            .map { dirent in
                let contentsJsonURL = URL(fileURLWithPath: "\(path)/\(dirent)/Contents.json")
                let jsonData = try Data(contentsOf: contentsJsonURL)
                let assetCatalogContents = try JSONDecoder().decode(ImageContent.self, from: jsonData)
                let hasImage = assetCatalogContents.images.filter { $0.filename != nil }.isEmpty == false
                
                if hasImage {
                    let baseName = contentsJsonURL.deletingLastPathComponent().deletingPathExtension().lastPathComponent
                    return baseName
                }
                
                return nil
            }
            
        return imagesName
            .compactMap { $0 }
            .map { ImageAsset(originalName: $0, camelCaseName: $0.toCamelCase) }
    }
}
