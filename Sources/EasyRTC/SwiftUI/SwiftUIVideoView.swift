import Foundation
import SwiftUI

/// A ``VideoView`` that can be used in SwiftUI.
/// Supports both iOS and macOS.
public struct SwiftUIVideoView: NativeViewRepresentable {
    public typealias ViewType = VideoView

    /// Pass a ``VideoTrack`` of a ``Participant``.
    let track: VideoTrack
    let layoutMode: VideoView.LayoutMode
    let mirrorMode: VideoView.MirrorMode
    let renderMode: VideoView.RenderMode
    let rotationOverride: VideoRotation?
    let pinchToZoomOptions: VideoView.PinchToZoomOptions
    let isDebugMode: Bool

    let videoViewDelegateReceiver: VideoViewDelegateReceiver

    public init(_ track: VideoTrack,
                layoutMode: VideoView.LayoutMode = .fill,
                mirrorMode: VideoView.MirrorMode = .auto,
                renderMode: VideoView.RenderMode = .auto,
                rotationOverride: VideoRotation? = nil,
                pinchToZoomOptions: VideoView.PinchToZoomOptions = [],
                isDebugMode: Bool = false,
                isRendering: Binding<Bool>? = nil)
    {
        self.track = track
        self.layoutMode = layoutMode
        self.mirrorMode = mirrorMode
        self.renderMode = renderMode
        self.rotationOverride = rotationOverride
        self.isDebugMode = isDebugMode
        self.pinchToZoomOptions = pinchToZoomOptions

        videoViewDelegateReceiver = VideoViewDelegateReceiver(isRendering: isRendering)
    }

    public func makeView(context: Context) -> VideoView {
        let view = VideoView()
        updateView(view, context: context)
        return view
    }

    public func updateView(_ videoView: VideoView, context _: Context) {
        videoView.track = track
        videoView.layoutMode = layoutMode
        videoView.mirrorMode = mirrorMode
        videoView.renderMode = renderMode
        videoView.rotationOverride = rotationOverride
        videoView.pinchToZoomOptions = pinchToZoomOptions
        videoView.isDebugMode = isDebugMode

        Task.detached { @MainActor in
            videoView.add(delegate: videoViewDelegateReceiver)
            videoViewDelegateReceiver.isRendering = videoView.isRendering
        }
    }

    public static func dismantleView(_ videoView: VideoView, coordinator _: ()) {
        videoView.track = nil
    }
}

/// This class receives ``VideoViewDelegate`` events since a struct can't be used for a delegate
class VideoViewDelegateReceiver: VideoViewDelegate, Loggable {
    @Binding var isRendering: Bool

    init(isRendering: Binding<Bool>?) {
        if let isRendering {
            _isRendering = isRendering
        } else {
            _isRendering = .constant(false)
        }
    }

    func videoView(_: VideoView, didUpdate isRendering: Bool) {
        DispatchQueue.main.async {
            self.isRendering = isRendering
        }
    }
}
