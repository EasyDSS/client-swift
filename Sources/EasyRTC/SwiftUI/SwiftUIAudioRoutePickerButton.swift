import AVKit
import SwiftUI

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

#if os(iOS) || os(macOS)
public struct SwiftUIAudioRoutePickerButton: NativeViewRepresentable {
    public init() {}

    public func makeView(context _: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()

        #if os(iOS)
        routePickerView.prioritizesVideoDevices = false
        #elseif os(macOS)
        routePickerView.isRoutePickerButtonBordered = false
        #endif

        return routePickerView
    }

    public func updateView(_: AVRoutePickerView, context _: Context) {}
    public static func dismantleView(_: AVRoutePickerView, coordinator _: ()) {}
}
#endif
