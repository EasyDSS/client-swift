import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public protocol TrackDelegate: AnyObject {
    /// Dimensions of the video track has updated
    @objc(track:didUpdateDimensions:) optional func track(_ track: VideoTrack, didUpdateDimensions dimensions: Dimensions?)

    /// Statistics for the track has been generated (v2).
    @objc(track:didUpdateStatistics:simulcastStatistics:) optional func track(_ track: Track, didUpdateStatistics: TrackStatistics, simulcastStatistics: [VideoCodec: TrackStatistics])
}

protocol TrackDelegateInternal: TrackDelegate {
    /// Notify RemoteTrackPublication to send isMuted state to server.
    func track(_ track: Track, didUpdateIsMuted isMuted: Bool, shouldSendSignal: Bool)

    /// Used to report track state mutation to TrackPublication if attached.
    func track(_ track: Track, didMutateState newState: Track.State, oldState: Track.State)
}
