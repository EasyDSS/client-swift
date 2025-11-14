/* -- */

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
    public let red: Bool

    @objc
    public let streamName: String?

    @objc
    public let preConnect: Bool

    public init(name: String? = nil,
                encoding: AudioEncoding? = nil,
                dtx: Bool = true,
                red: Bool = true,
                streamName: String? = nil,
                preConnect: Bool = false)
    {
        self.name = name
        self.encoding = encoding
        self.dtx = dtx
        self.red = red
        self.streamName = streamName
        self.preConnect = preConnect
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return name == other.name &&
            encoding == other.encoding &&
            dtx == other.dtx &&
            red == other.red &&
            streamName == other.streamName &&
            preConnect == other.preConnect
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(name)
        hasher.combine(encoding)
        hasher.combine(dtx)
        hasher.combine(red)
        hasher.combine(streamName)
        hasher.combine(preConnect)
        return hasher.finalize()
    }
}

// Internal
extension AudioPublishOptions {
    func toFeatures() -> Set<Livekit_AudioTrackFeature> {
        Set([
            !dtx ? .tfNoDtx : nil,
            preConnect ? .tfPreconnectBuffer : nil,
        ].compactMap { $0 })
    }
}

extension AudioPublishOptions {
    func withPreconnect(_ enabled: Bool) -> AudioPublishOptions {
        AudioPublishOptions(
            name: name,
            encoding: encoding,
            dtx: dtx,
            red: red,
            streamName: streamName,
            preConnect: enabled
        )
    }
}
