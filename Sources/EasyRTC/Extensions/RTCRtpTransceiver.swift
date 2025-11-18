import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

extension LKRTCRtpTransceiver: Loggable {
    /// Attempts to set preferred video codec.
    func set(preferredVideoCodec codec: VideoCodec, exceptCodec: VideoCodec? = nil) {
        // Get list of supported codecs...
        let allVideoCodecs = RTC.videoSenderCapabilities.codecs

        // Get the RTCRtpCodecCapability of the preferred codec
        let preferredCodecCapability = allVideoCodecs.first { $0.name.lowercased() == codec.id }

        // Get list of capabilities other than the preferred one
        let otherCapabilities = allVideoCodecs.filter {
            $0.name.lowercased() != codec.id && $0.name.lowercased() != exceptCodec?.id
        }

        // Bring preferredCodecCapability to the front and combine all capabilities
        let combinedCapabilities = [preferredCodecCapability] + otherCapabilities

        // Codecs not set in codecPreferences will not be negotiated in the offer
        codecPreferences = combinedCapabilities.compactMap { $0 }

        log("codecPreferences set: \(codecPreferences.map { String(describing: $0) }.joined(separator: ", "))")

        if codecPreferences.first?.name.lowercased() != codec.id {
            log("Preferred codec is not first of codecPreferences", .error)
        }
    }
}
