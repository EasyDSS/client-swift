/* -- */

internal import LiveKitWebRTC

import Foundation

// Wrapper for LKRTCAudioBuffer
@objc
public class LKAudioBuffer: NSObject {
    private let _audioBuffer: LKRTCAudioBuffer

    @objc
    public var channels: Int { _audioBuffer.channels }

    @objc
    public var frames: Int { _audioBuffer.frames }

    @objc
    public var framesPerBand: Int { _audioBuffer.framesPerBand }

    @objc
    public var bands: Int { _audioBuffer.bands }

    @objc
    @available(*, deprecated, renamed: "rawBuffer(forChannel:)")
    public func rawBuffer(for channel: Int) -> UnsafeMutablePointer<Float> {
        _audioBuffer.rawBuffer(forChannel: channel)
    }

    @objc
    public func rawBuffer(forChannel channel: Int) -> UnsafeMutablePointer<Float> {
        _audioBuffer.rawBuffer(forChannel: channel)
    }

    init(audioBuffer: LKRTCAudioBuffer) {
        _audioBuffer = audioBuffer
    }
}
