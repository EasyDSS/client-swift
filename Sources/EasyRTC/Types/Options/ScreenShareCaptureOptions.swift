import Foundation

@objc
public final class ScreenShareCaptureOptions: NSObject, VideoCaptureOptions, Sendable {
    @objc
    public let dimensions: Dimensions

    @objc
    public let fps: Int

    /// Only used for macOS
    @objc
    public let showCursor: Bool

    @objc
    public let useBroadcastExtension: Bool

    @objc
    public let includeCurrentApplication: Bool

    public init(dimensions: Dimensions = .h1080_169,
                fps: Int = 30,
                showCursor: Bool = true,
                useBroadcastExtension: Bool = false,
                includeCurrentApplication: Bool = false)
    {
        self.dimensions = dimensions
        self.fps = fps
        self.showCursor = showCursor
        self.useBroadcastExtension = useBroadcastExtension
        self.includeCurrentApplication = includeCurrentApplication
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return dimensions == other.dimensions &&
            fps == other.fps &&
            showCursor == other.showCursor &&
            useBroadcastExtension == other.useBroadcastExtension &&
            includeCurrentApplication == other.includeCurrentApplication
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(dimensions)
        hasher.combine(fps)
        hasher.combine(showCursor)
        hasher.combine(useBroadcastExtension)
        hasher.combine(includeCurrentApplication)
        return hasher.finalize()
    }
}
