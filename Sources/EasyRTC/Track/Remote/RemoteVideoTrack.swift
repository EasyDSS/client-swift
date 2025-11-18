#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public class RemoteVideoTrack: Track, RemoteTrack {
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

extension RemoteVideoTrack: VideoTrack {
    public func add(videoRenderer: VideoRenderer) {
        guard let rtcVideoTrack = mediaTrack as? LKRTCVideoTrack else {
            log("mediaTrack is not a RTCVideoTrack", .error)
            return
        }

        _state.mutate {
            $0.videoRenderers.add(videoRenderer)
        }

        rtcVideoTrack.add(VideoRendererAdapter(target: videoRenderer))
    }

    public func remove(videoRenderer: VideoRenderer) {
        guard let rtcVideoTrack = mediaTrack as? LKRTCVideoTrack else {
            log("mediaTrack is not a RTCVideoTrack", .error)
            return
        }

        _state.mutate {
            $0.videoRenderers.remove(videoRenderer)
        }

        rtcVideoTrack.remove(VideoRendererAdapter(target: videoRenderer))
    }
}
