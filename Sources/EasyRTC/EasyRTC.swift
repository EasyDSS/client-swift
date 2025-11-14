/* -- */

import Foundation
internal import LiveKitWebRTC

@objc
public class EasyRTCSDK: NSObject, Loggable {
    override private init() {}

    @objc(sdkVersion)
    public static let version = "2.9.0"

    fileprivate struct State {
        var logger: Logger = OSLogger()
    }

    fileprivate static let state = StateSync(State())

    /// Set a custom logger for the SDK
    /// - Note: This method must be called before any other logging is done
    /// e.g. in the `App.init()` or `AppDelegate/SceneDelegate`
    public static func setLogger(_ logger: Logger) {
        state.mutate { $0.logger = logger }
    }

    /// Adjust the minimum log level for the default `OSLogger`
    /// - Note: This method must be called before any other logging is done
    /// e.g. in the `App.init()` or `AppDelegate/SceneDelegate`
    @objc
    public static func setLogLevel(_ level: LogLevel) {
        setLogger(OSLogger(minLevel: level))
    }

    /// Disable logging for the SDK
    /// - Note: This method must be called before any other logging is done
    /// e.g. in the `App.init()` or `AppDelegate/SceneDelegate`
    @objc
    public static func disableLogging() {
        setLogger(DisabledLogger())
    }

    @available(*, deprecated, renamed: "setLogLevel")
    @objc
    public static func setLoggerStandardOutput() {
        setLogLevel(.debug)
    }

    /// Notify the SDK to start initializing for faster connection/publishing later on. This is non-blocking.
    @objc
    public static func prepare() {
        // TODO: Add RTC related initializations
        DeviceManager.prepare()
    }
}

// Lazily initialized to the first logger
let sharedLogger = EasyRTCSDK.state.logger
