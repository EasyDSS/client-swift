/* -- */

import Foundation

@objc
public protocol AudioTrackProtocol: AnyObject, Sendable {
    @objc(addAudioRenderer:)
    func add(audioRenderer: AudioRenderer)

    @objc(removeAudioRenderer:)
    func remove(audioRenderer: AudioRenderer)
}

public typealias AudioTrack = AudioTrackProtocol & Track
