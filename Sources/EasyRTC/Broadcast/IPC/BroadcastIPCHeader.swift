/* -- */

#if os(iOS)

/// Message header for communication between uploader and receiver.
enum BroadcastIPCHeader: Codable {
    /// Image sample sent by uploader.
    case image(BroadcastImageCodec.Metadata, VideoRotation)

    /// Audio sample sent by uploader.
    case audio(BroadcastAudioCodec.Metadata)

    /// Request sent by receiver to set audio demand.
    case wantsAudio(Bool)
}

#endif
