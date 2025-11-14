/* -- */

public protocol Codec: Identifiable, Sendable {
    var name: String { get }
    var mediaType: String { get }
    static func from(name: String) -> Self?
    static func from(mimeType: String) -> Self?
}

public extension Codec {
    // Identifiable by mimeString
    var id: String {
        mimeType
    }

    var mimeType: String {
        "\(mediaType)/\(name)"
    }
}
