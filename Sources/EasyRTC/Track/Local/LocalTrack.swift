import Foundation

@objc
public protocol LocalTrack where Self: Track {
    @objc
    var publishOptions: TrackPublishOptions? { get }

    @objc
    var publishState: PublishState { get }

    @objc
    func mute() async throws

    @objc
    func unmute() async throws
}
