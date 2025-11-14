/* -- */

import AVFAudio

internal import LiveKitWebRTC

public let AudioEngineInputMixerNodeKey = kLKRTCAudioEngineInputMixerNodeKey

/// Do not retain the engine object.
public protocol AudioEngineObserver: NextInvokable, Sendable {
    associatedtype Next = any AudioEngineObserver
    var next: (any AudioEngineObserver)? { get set }

    func engineDidCreate(_ engine: AVAudioEngine) -> Int
    func engineWillEnable(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int
    func engineWillStart(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int
    func engineDidStop(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int
    func engineDidDisable(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int
    func engineWillRelease(_ engine: AVAudioEngine) -> Int

    /// Provide custom implementation for internal AVAudioEngine's output configuration.
    /// Buffers flow from `src` to `dst`. Preferred format to connect node is provided as `format`.
    /// Return true if custom implementation is provided, otherwise default implementation will be used.
    func engineWillConnectOutput(_ engine: AVAudioEngine, src: AVAudioNode, dst: AVAudioNode?, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int
    /// Provide custom implementation for internal AVAudioEngine's input configuration.
    /// Buffers flow from `src` to `dst`. Preferred format to connect node is provided as `format`.
    /// Return true if custom implementation is provided, otherwise default implementation will be used.
    func engineWillConnectInput(_ engine: AVAudioEngine, src: AVAudioNode?, dst: AVAudioNode, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int
}

/// Default implementation to make it optional.
public extension AudioEngineObserver {
    func engineDidCreate(_ engine: AVAudioEngine) -> Int {
        next?.engineDidCreate(engine) ?? 0
    }

    func engineWillEnable(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        next?.engineWillEnable(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func engineWillStart(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        next?.engineWillStart(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func engineDidStop(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        next?.engineDidStop(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func engineDidDisable(_ engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        next?.engineDidDisable(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func engineWillRelease(_ engine: AVAudioEngine) -> Int {
        next?.engineWillRelease(engine) ?? 0
    }

    func engineWillConnectOutput(_ engine: AVAudioEngine, src: AVAudioNode, dst: AVAudioNode?, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int {
        next?.engineWillConnectOutput(engine, src: src, dst: dst, format: format, context: context) ?? 0
    }

    func engineWillConnectInput(_ engine: AVAudioEngine, src: AVAudioNode?, dst: AVAudioNode, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int {
        next?.engineWillConnectInput(engine, src: src, dst: dst, format: format, context: context) ?? 0
    }
}
