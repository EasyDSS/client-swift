/* -- */

import AVFoundation

internal import LiveKitWebRTC

@objc
public protocol VideoRenderer: Sendable {
    /// Whether this ``VideoRenderer`` should be considered visible or not for AdaptiveStream.
    /// This will be invoked on the .main thread.
    @objc
    @MainActor var isAdaptiveStreamEnabled: Bool { get }
    /// The size used for AdaptiveStream computation. Return .zero if size is unknown yet.
    /// This will be invoked on the .main thread.
    @objc
    @MainActor var adaptiveStreamSize: CGSize { get }

    /// Size of the frame.
    @objc optional
    nonisolated func set(size: CGSize)

    /// A ``VideoFrame`` is ready and should be processed.
    @objc optional
    nonisolated func render(frame: VideoFrame)

    /// In addition to ``VideoFrame``, provide capture-time information if available.
    @objc optional
    nonisolated func render(frame: VideoFrame, captureDevice: AVCaptureDevice?, captureOptions: VideoCaptureOptions?)
}

final class VideoRendererAdapter: NSObject, LKRTCVideoRenderer {
    weak var renderer: VideoRenderer?

    init(renderer: VideoRenderer) {
        self.renderer = renderer
    }

    func setSize(_ size: CGSize) {
        renderer?.set?(size: size)
    }

    func renderFrame(_ frame: LKRTCVideoFrame?) {
        guard let frame = frame?.toLKType() else { return }
        renderer?.render?(frame: frame)
        renderer?.render?(frame: frame, captureDevice: nil, captureOptions: nil)
    }
}
