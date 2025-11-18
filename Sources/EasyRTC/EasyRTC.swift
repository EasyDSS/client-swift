import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
internal import Logging
#else
@_implementationOnly import LiveKitWebRTC
@_implementationOnly import Logging
#endif

let logger = Logger(label: "EasyRTCSwift")

/// The open source platform for real-time communication.
///
/// See [LiveKit's Online Docs](https://docs.livekit.io/) for more information.
///
/// Comments are written in [DocC](https://developer.apple.com/documentation/docc) compatible format.
/// With Xcode 13 and above you can build documentation right into your Xcode documentation viewer by chosing
/// **Product** >  **Build Documentation** from Xcode's menu.
///
/// Download the [Multiplatform SwiftUI Example](https://github.com/livekit/multiplatform-swiftui-example)
/// to try out the features.
@objc
public class EasyRTCSDK: NSObject {
    @objc(sdkVersion)
    public static let version = "2.0.18"

    @objc
    public static func setLoggerStandardOutput() {
        LoggingSystem.bootstrap {
            var logHandler = StreamLogHandler.standardOutput(label: $0)
            logHandler.logLevel = .debug
            return logHandler
        }
    }

    /// Notify the SDK to start initializing for faster connection/publishing later on. This is non-blocking.
    @objc
    public static func prepare() {
        // TODO: Add RTC related initializations
        DeviceManager.prepare()
    }
}
