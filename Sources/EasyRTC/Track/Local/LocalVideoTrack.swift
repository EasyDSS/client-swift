/* -- */

import Foundation

internal import LiveKitWebRTC

@objc
public class LocalVideoTrack: Track, LocalTrackProtocol, @unchecked Sendable {
    @objc
    public internal(set) var capturer: VideoCapturer

    var videoSource: LKRTCVideoSource

    init(name: String,
         source: Track.Source,
         capturer: VideoCapturer,
         videoSource: LKRTCVideoSource,
         reportStatistics: Bool)
    {
        let rtcTrack = RTC.createVideoTrack(source: videoSource)
        rtcTrack.isEnabled = true

        self.capturer = capturer
        self.videoSource = videoSource

        super.init(name: name,
                   kind: .video,
                   source: source,
                   track: rtcTrack,
                   reportStatistics: reportStatistics)
    }

    public func mute() async throws {
        try await super._mute()
    }

    public func unmute() async throws {
        try await super._unmute()
    }

    // MARK: - Internal

    override func startCapture() async throws {
        try await capturer.startCapture()
    }

    override func stopCapture() async throws {
        try await capturer.stopCapture()
    }
}

// MARK: - VideoTrack Protocol

extension LocalVideoTrack: VideoTrackProtocol {
    public func add(videoRenderer: VideoRenderer) {
        capturer.rendererDelegates.add(delegate: videoRenderer)
    }

    public func remove(videoRenderer: VideoRenderer) {
        capturer.rendererDelegates.remove(delegate: videoRenderer)
    }
}

public extension LocalVideoTrack {
    var publishOptions: TrackPublishOptions? { super._state.lastPublishOptions }
    var publishState: Track.PublishState { super._state.publishState }

    /// Convenience access to ``VideoCapturer/processor``.
    var processor: VideoProcessor? {
        get { capturer._state.processor }
        set { capturer._state.mutate { $0.processor = newValue } }
    }
}

public extension LocalVideoTrack {
    /// Clone with same ``VideoCapturer``.
    func clone() -> LocalVideoTrack {
        LocalVideoTrack(name: name,
                        source: source,
                        capturer: capturer,
                        videoSource: videoSource,
                        reportStatistics: _state.reportStatistics)
    }
}
