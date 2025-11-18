import Foundation

/// Base protocol for ``DataPublishOptions`` and ``MediaPublishOptions``.
@objc
public protocol PublishOptions {}

/// Base protocol for both ``VideoPublishOptions`` and ``AudioPublishOptions``.
@objc
public protocol TrackPublishOptions: PublishOptions {
    var name: String? { get }
    /// Set stream name for the track. Audio and video tracks with the same stream name
    /// will be placed in the same `MediaStream` and offer better synchronization.
    /// By default, camera and microphone will be placed in a stream; as would screen_share and screen_share_audio
    var streamName: String? { get }
}
