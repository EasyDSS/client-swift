/* -- */

import Foundation

internal import LiveKitWebRTC

extension LKRTCRtpTransceiver: Loggable {
    /// Attempts to set preferred video codec.
    func set(preferredVideoCodec codec: VideoCodec, exceptCodec: VideoCodec? = nil) throws {
        // Get list of supported codecs...
        let allVideoCodecs = RTC.videoSenderCapabilities.codecs

        // Get the RTCRtpCodecCapability of the preferred codec
        let preferredCodecCapability = allVideoCodecs.first { $0.name.lowercased() == codec.name }

        // Get list of capabilities other than the preferred one
        let otherCapabilities = allVideoCodecs.filter {
            $0.name.lowercased() != codec.name && $0.name.lowercased() != exceptCodec?.name
        }

        // Bring preferredCodecCapability to the front and combine all capabilities
        let combinedCapabilities = [preferredCodecCapability] + otherCapabilities

        // Codecs not set in codecPreferences will not be negotiated in the offer
        do {
            try setCodecPreferences(combinedCapabilities.compactMap { $0 }, error: ())
        } catch {
            throw LiveKitError(.webRTC, message: "Failed to set codec preferences", internalError: error)
        }

        log("codecPreferences set: \(codecPreferences.map { String(describing: $0) }.joined(separator: ", "))")

        if codecPreferences.first?.name.lowercased() != codec.name {
            log("Preferred codec is not first of codecPreferences", .error)
        }
    }
}
