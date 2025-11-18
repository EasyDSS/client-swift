import Foundation

@objc
public final class VideoEncoding: NSObject, MediaEncoding, Sendable {
    @objc
    public let maxBitrate: Int

    @objc
    public let maxFps: Int

    @objc
    public init(maxBitrate: Int, maxFps: Int) {
        self.maxBitrate = maxBitrate
        self.maxFps = maxFps
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return maxBitrate == other.maxBitrate &&
            maxFps == other.maxFps
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(maxBitrate)
        hasher.combine(maxFps)
        return hasher.finalize()
    }
}
