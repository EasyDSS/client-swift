/* -- */

import Foundation

@objc
public protocol LocalTrackProtocol: AnyObject, Sendable {
    @objc
    var publishOptions: TrackPublishOptions? { get }

    @objc
    var publishState: Track.PublishState { get }

    @objc
    func mute() async throws

    @objc
    func unmute() async throws
}

public typealias LocalTrack = LocalTrackProtocol & Track
