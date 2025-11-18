import Foundation

// MARK: - Equatable for NSObject

public extension Track {
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return mediaTrack.trackId == other.mediaTrack.trackId
    }

    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(mediaTrack.trackId)
        return hasher.finalize()
    }
}
