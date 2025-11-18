import AVFoundation
import CoreMedia

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public class RemoteAudioTrack: Track, RemoteTrack, AudioTrack {
    /// Volume with range 0.0 - 1.0
    public var volume: Double {
        get {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return 0 }
            return audioTrack.source.volume / 10
        }
        set {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
            audioTrack.source.volume = newValue * 10
        }
    }

    private lazy var _adapter = AudioRendererAdapter()

    init(name: String,
         source: Track.Source,
         track: LKRTCMediaStreamTrack,
         reportStatistics: Bool)
    {
        super.init(name: name,
                   kind: .audio,
                   source: source,
                   track: track,
                   reportStatistics: reportStatistics)
    }

    deinit {
        // Directly remove the adapter without unnecessary checks
        guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
        audioTrack.remove(_adapter)
    }

    public func add(audioRenderer: AudioRenderer) {
        let wasEmpty = _adapter.countDelegates == 0
        _adapter.add(delegate: audioRenderer)
        // Attach adapter only if it wasn't attached before
        if wasEmpty {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
            audioTrack.add(_adapter)
        }
    }

    public func remove(audioRenderer: AudioRenderer) {
        _adapter.remove(delegate: audioRenderer)
        // Remove adapter only if there are no more delegates
        if _adapter.countDelegates == 0 {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
            audioTrack.remove(_adapter)
        }
    }

    // MARK: - Internal

    override func startCapture() async throws {
        try await AudioManager.shared.trackDidStart(.remote)
    }

    override func stopCapture() async throws {
        try await AudioManager.shared.trackDidStop(.remote)
    }
}
