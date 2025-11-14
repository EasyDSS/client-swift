/* -- */

internal import LiveKitWebRTC

@objc
public class RemoteVideoTrack: Track, RemoteTrackProtocol, @unchecked Sendable {
    init(name: String,
         source: Track.Source,
         track: LKRTCMediaStreamTrack,
         reportStatistics: Bool)
    {
        super.init(name: name,
                   kind: .video,
                   source: source,
                   track: track,
                   reportStatistics: reportStatistics)
    }
}

// MARK: - VideoTrack Protocol

extension RemoteVideoTrack: VideoTrackProtocol {
    public func add(videoRenderer: VideoRenderer) {
        guard let rtcVideoTrack = mediaTrack as? LKRTCVideoTrack else {
            log("mediaTrack is not a RTCVideoTrack", .error)
            return
        }

        let adapter = VideoRendererAdapter(renderer: videoRenderer)

        _state.mutate {
            $0.videoRendererAdapters.setObject(adapter, forKey: videoRenderer)
        }

        rtcVideoTrack.add(adapter)
    }

    public func remove(videoRenderer: VideoRenderer) {
        guard let rtcVideoTrack = mediaTrack as? LKRTCVideoTrack else {
            log("mediaTrack is not a RTCVideoTrack", .error)
            return
        }

        let adapter = _state.mutate {
            let adapter = $0.videoRendererAdapters.object(forKey: videoRenderer)
            $0.videoRendererAdapters.removeObject(forKey: videoRenderer)
            return adapter
        }

        guard let adapter else {
            log("No adapter found for videoRenderer", .warning)
            return
        }

        rtcVideoTrack.remove(adapter)
    }
}
