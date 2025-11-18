import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public final class BufferCaptureOptions: NSObject, VideoCaptureOptions, Sendable {
    @objc
    public let dimensions: Dimensions

    @objc
    public let fps: Int

    public init(dimensions: Dimensions = .h1080_169,
                fps: Int = 15)
    {
        self.dimensions = dimensions
        self.fps = fps
    }

    public init(from options: ScreenShareCaptureOptions) {
        dimensions = options.dimensions
        fps = options.fps
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return dimensions == other.dimensions &&
            fps == other.fps
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(dimensions)
        hasher.combine(fps)
        return hasher.finalize()
    }
}
