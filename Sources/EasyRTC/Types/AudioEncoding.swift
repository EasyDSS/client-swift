import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public final class AudioEncoding: NSObject, MediaEncoding, Sendable {
    @objc
    public let maxBitrate: Int

    @objc
    public init(maxBitrate: Int) {
        self.maxBitrate = maxBitrate
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return maxBitrate == other.maxBitrate
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(maxBitrate)
        return hasher.finalize()
    }
}

// MARK: - Presets

@objc
public extension AudioEncoding {
    internal static let presets = [
        presetTelephone,
        presetSpeech,
        presetMusic,
        presetMusicStereo,
        presetMusicHighQuality,
        presetMusicHighQualityStereo,
    ]

    static let presetTelephone = AudioEncoding(maxBitrate: 12000)
    static let presetSpeech = AudioEncoding(maxBitrate: 20000)
    static let presetMusic = AudioEncoding(maxBitrate: 32000)
    static let presetMusicStereo = AudioEncoding(maxBitrate: 48000)
    static let presetMusicHighQuality = AudioEncoding(maxBitrate: 64000)
    static let presetMusicHighQualityStereo = AudioEncoding(maxBitrate: 96000)
}
