/* -- */

import Foundation

internal import LiveKitWebRTC

// Invoked on WebRTC's worker thread, do not block.
class AudioDeviceModuleDelegateAdapter: NSObject, LKRTCAudioDeviceModuleDelegate, Loggable {
    weak var audioManager: AudioManager?

    func audioDeviceModule(_: LKRTCAudioDeviceModule, didReceiveSpeechActivityEvent speechActivityEvent: LKRTCSpeechActivityEvent) {
        guard let audioManager else { return }
        audioManager._state.onMutedSpeechActivity?(audioManager, speechActivityEvent.toLKType())
    }

    func audioDeviceModuleDidUpdateDevices(_: LKRTCAudioDeviceModule) {
        guard let audioManager else { return }
        audioManager._state.onDevicesDidUpdate?(audioManager)
    }

    // Engine events

    func audioDeviceModule(_: LKRTCAudioDeviceModule, didCreateEngine engine: AVAudioEngine) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineDidCreate(engine) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, willEnableEngine engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineWillEnable(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, willStartEngine engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineWillStart(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, didStopEngine engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineDidStop(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, didDisableEngine engine: AVAudioEngine, isPlayoutEnabled: Bool, isRecordingEnabled: Bool) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineDidDisable(engine, isPlayoutEnabled: isPlayoutEnabled, isRecordingEnabled: isRecordingEnabled) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, willReleaseEngine engine: AVAudioEngine) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineWillRelease(engine) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, engine: AVAudioEngine, configureInputFromSource src: AVAudioNode?, toDestination dst: AVAudioNode, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineWillConnectInput(engine, src: src, dst: dst, format: format, context: context) ?? 0
    }

    func audioDeviceModule(_: LKRTCAudioDeviceModule, engine: AVAudioEngine, configureOutputFromSource src: AVAudioNode, toDestination dst: AVAudioNode?, format: AVAudioFormat, context: [AnyHashable: Any]) -> Int {
        guard let audioManager else { return 0 }
        let entryPoint = audioManager.buildEngineObserverChain()
        return entryPoint?.engineWillConnectOutput(engine, src: src, dst: dst, format: format, context: context) ?? 0
    }
}
