import Foundation

@objc
public final class VideoPublishOptions: NSObject, TrackPublishOptions, Sendable {
    @objc
    public let name: String?

    /// preferred encoding parameters
    @objc
    public let encoding: VideoEncoding?

    /// encoding parameters for for screen share
    @objc
    public let screenShareEncoding: VideoEncoding?

    /// true to enable simulcasting, publishes three tracks at different sizes
    @objc
    public let simulcast: Bool

    @objc
    public let simulcastLayers: [VideoParameters]

    @objc
    public let screenShareSimulcastLayers: [VideoParameters]

    @objc
    public let preferredCodec: VideoCodec?

    @objc
    public let preferredBackupCodec: VideoCodec?

    @objc
    public let degradationPreference: DegradationPreference

    @objc
    public let streamName: String?

    public init(name: String? = nil,
                encoding: VideoEncoding? = nil,
                screenShareEncoding: VideoEncoding? = nil,
                simulcast: Bool = true,
                simulcastLayers: [VideoParameters] = [],
                screenShareSimulcastLayers: [VideoParameters] = [],
                preferredCodec: VideoCodec? = nil,
                preferredBackupCodec: VideoCodec? = nil,
                degradationPreference: DegradationPreference = .auto,
                streamName: String? = nil)
    {
        self.name = name
        self.encoding = encoding
        self.screenShareEncoding = screenShareEncoding
        self.simulcast = simulcast
        self.simulcastLayers = simulcastLayers
        self.screenShareSimulcastLayers = screenShareSimulcastLayers
        self.preferredCodec = preferredCodec
        self.preferredBackupCodec = preferredBackupCodec
        self.degradationPreference = degradationPreference
        self.streamName = streamName
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return name == other.name &&
            encoding == other.encoding &&
            screenShareEncoding == other.screenShareEncoding &&
            simulcast == other.simulcast &&
            simulcastLayers == other.simulcastLayers &&
            screenShareSimulcastLayers == other.screenShareSimulcastLayers &&
            preferredCodec == other.preferredCodec &&
            preferredBackupCodec == other.preferredBackupCodec &&
            degradationPreference == other.degradationPreference &&
            streamName == other.streamName
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(name)
        hasher.combine(encoding)
        hasher.combine(screenShareEncoding)
        hasher.combine(simulcast)
        hasher.combine(simulcastLayers)
        hasher.combine(screenShareSimulcastLayers)
        hasher.combine(preferredCodec)
        hasher.combine(preferredBackupCodec)
        hasher.combine(degradationPreference)
        hasher.combine(streamName)
        return hasher.finalize()
    }
}
