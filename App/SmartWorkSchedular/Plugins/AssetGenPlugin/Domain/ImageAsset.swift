import Foundation

/// Representation for Content.json file of Image asset
struct ImageContent: Decodable {
    let images: [ImageAsset]
}

/// Representation of Image asset
struct ImageAsset: Decodable {
    let filename: String?
}
