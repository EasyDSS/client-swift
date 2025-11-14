/* -- */

import Foundation

internal import LiveKitWebRTC

@objc
public protocol VideoViewDelegate: AnyObject, Sendable {
    /// Dimensions of the VideoView itself has updated
    @objc(videoView:didUpdateSize:) optional
    func videoView(_ videoView: VideoView, didUpdate size: CGSize)
    /// VideoView updated the isRendering property
    @objc(videoView:didUpdateIsRendering:) optional
    func videoView(_ videoView: VideoView, didUpdate isRendering: Bool)
}
