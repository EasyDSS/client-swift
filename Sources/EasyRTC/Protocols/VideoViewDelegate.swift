import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public protocol VideoViewDelegate: AnyObject {
    /// Dimensions of the VideoView itself has updated
    @objc(videoView:didUpdateSize:) optional func videoView(_ videoView: VideoView, didUpdate size: CGSize)
    /// VideoView updated the isRendering property
    @objc(videoView:didUpdateIsRendering:) optional func videoView(_ videoView: VideoView, didUpdate isRendering: Bool)
}
