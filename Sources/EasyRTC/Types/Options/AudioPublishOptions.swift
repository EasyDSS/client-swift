import Foundation

@objc
public final class AudioPublishOptions: NSObject, TrackPublishOptions, Sendable {
    @objc
    public let name: String?

    /// preferred encoding parameters
    @objc
    public let encoding: AudioEncoding?

    @objc
    public let dtx: Bool

    @objc
    public let streamName: String?

    public init(name: String? = nil,
                encoding: AudioEncoding? = nil,
                dtx: Bool = true,
                streamName: String? = nil)
    {
        self.name = name
        self.encoding = encoding
        self.dtx = dtx
        self.streamName = streamName
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return name == other.name &&
            encoding == other.encoding &&
            dtx == other.dtx &&
            streamName == other.streamName
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(name)
        hasher.combine(encoding)
        hasher.combine(dtx)
        hasher.combine(streamName)
        return hasher.finalize()
    }
}

// Internal
extension AudioPublishOptions {
    func toFeatures() -> Set<Livekit_AudioTrackFeature> {
        Set([
            !dtx ? .tfNoDtx : nil,
        ].compactMap { $0 })
    }
}
