import Foundation

/// Default timeout `TimeInterval`s used throughout the SDK.
public extension TimeInterval {
    static let defaultReconnectAttemptDelay: Self = 2
    // the following 3 timeouts are used for a typical connect sequence
    static let defaultSocketConnect: Self = 10
    // used for validation mode
    static let defaultHTTPConnect: Self = 5

    static let defaultJoinResponse: Self = 7
    static let defaultTransportState: Self = 10
    static let defaultPublisherDataChannelOpen: Self = 7
    static let resolveSid: Self = 7 + 5 // Join response + 5
    static let defaultPublish: Self = 10
    static let defaultCaptureStart: Self = 10
}

extension TimeInterval {
    var toDispatchTimeInterval: DispatchTimeInterval {
        .milliseconds(Int(self * 1000))
    }
}
