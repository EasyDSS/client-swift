/* -- */

import AVFoundation
import CoreMedia

internal import LiveKitWebRTC

@objc
public class RemoteAudioTrack: Track, RemoteTrackProtocol, AudioTrackProtocol, @unchecked Sendable {
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

        if let audioTrack = mediaTrack as? LKRTCAudioTrack {
            audioTrack.add(_adapter)
        }
    }

    deinit {
        if let audioTrack = mediaTrack as? LKRTCAudioTrack {
            audioTrack.remove(_adapter)
        }
    }

    public func add(audioRenderer: AudioRenderer) {
        _adapter.add(delegate: audioRenderer)
    }

    public func remove(audioRenderer: AudioRenderer) {
        _adapter.remove(delegate: audioRenderer)
    }
}
