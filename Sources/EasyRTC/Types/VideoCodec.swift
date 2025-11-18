import Foundation

@objc
public final class VideoCodec: NSObject, Identifiable, Sendable {
    public static func from(id: String) throws -> VideoCodec {
        // Try to find codec from id...
        guard let codec = all.first(where: { $0.id == id }) else {
            throw LiveKitError(.invalidState, message: "Failed to create VideoCodec from id")
        }

        return codec
    }

    public static func from(mimeType: String) throws -> VideoCodec {
        let parts = mimeType.lowercased().split(separator: "/")
        var id = String(parts.first!)
        if parts.count > 1 {
            if parts[0] != "video" { throw LiveKitError(.invalidState, message: "MIME type must be video") }
            id = String(parts[1])
        }
        return try from(id: id)
    }

    public static let h264 = VideoCodec(id: "h264", backup: true)
    public static let vp8 = VideoCodec(id: "vp8", backup: true)
    public static let vp9 = VideoCodec(id: "vp9", isSVC: true)
    public static let av1 = VideoCodec(id: "av1", isSVC: true)

    public static let all: [VideoCodec] = [.h264, .vp8, .vp9, .av1]
    public static let allBackup: [VideoCodec] = [.h264, .vp8]

    // codec Id
    public let id: String
    // Whether the codec can be used as `backup`
    public let isBackup: Bool
    // Whether the codec can be used as `backup`
    public let isSVC: Bool

    // Internal only
    init(id: String,
         backup: Bool = false,
         isSVC: Bool = false)
    {
        self.id = id
        isBackup = backup
        self.isSVC = isSVC
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return id == other.id
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }

    override public var description: String {
        "VideoCodec(id: \(id))"
    }
}

extension Livekit_SubscribedCodec {
    func toVideoCodec() throws -> VideoCodec {
        try VideoCodec.from(id: codec)
    }
}
