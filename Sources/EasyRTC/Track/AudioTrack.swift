import Foundation

@objc
public protocol AudioTrack where Self: Track {
    @objc(addAudioRenderer:)
    func add(audioRenderer: AudioRenderer)

    @objc(removeAudioRenderer:)
    func remove(audioRenderer: AudioRenderer)
}
