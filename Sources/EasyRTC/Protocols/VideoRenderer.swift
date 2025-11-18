import AVFoundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public protocol VideoRenderer {
    /// Whether this ``VideoRenderer`` should be considered visible or not for AdaptiveStream.
    /// This will be invoked on the .main thread.
    @objc
    var isAdaptiveStreamEnabled: Bool { get }
    /// The size used for AdaptiveStream computation. Return .zero if size is unknown yet.
    /// This will be invoked on the .main thread.
    @objc
    var adaptiveStreamSize: CGSize { get }

    /// Size of the frame.
    @objc optional func set(size: CGSize)

    /// A ``VideoFrame`` is ready and should be processed.
    @objc optional func render(frame: VideoFrame)

    /// In addition to ``VideoFrame``, provide capture-time information if available.
    @objc optional func render(frame: VideoFrame, captureDevice: AVCaptureDevice?, captureOptions: VideoCaptureOptions?)
}

class VideoRendererAdapter: NSObject, LKRTCVideoRenderer {
    private weak var target: VideoRenderer?

    init(target: VideoRenderer) {
        self.target = target
    }

    func setSize(_ size: CGSize) {
        target?.set?(size: size)
    }

    func renderFrame(_ frame: LKRTCVideoFrame?) {
        guard let frame = frame?.toLKType() else { return }
        target?.render?(frame: frame)
        target?.render?(frame: frame, captureDevice: nil, captureOptions: nil)
    }

    // Proxy the equality operators

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? VideoRendererAdapter else { return false }
        return target === other.target
    }

    override var hash: Int {
        guard let target else { return 0 }
        return ObjectIdentifier(target).hashValue
    }
}
