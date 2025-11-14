/* -- */

internal import LiveKitWebRTC

public enum AudioDeviceModuleType {
    /// Use AVAudioEngine-based AudioDeviceModule internally which will be used for all platforms.
    case audioEngine
    /// Use WebRTC's default AudioDeviceModule internally, which uses AudioUnit for iOS, HAL APIs for macOS.
    case platformDefault
}

extension AudioDeviceModuleType {
    func toRTCType() -> LKRTCAudioDeviceModuleType {
        switch self {
        case .audioEngine: LKRTCAudioDeviceModuleType.audioEngine
        case .platformDefault: LKRTCAudioDeviceModuleType.platformDefault
        }
    }
}

public extension AudioManager {
    /// Sets the desired `AudioDeviceModuleType` to be used which handles all audio input / output.
    ///
    /// This method must be called before the peer connection is initialized. Changing the module type after
    /// initialization is not supported and will result in an error.
    ///
    /// Note: When using .platformDefault, AVAudioSession will not be automatically managed.
    /// Ensure to set session category when accessing the mic:
    /// `try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .videoChat, options: [])`
    static func set(audioDeviceModuleType: AudioDeviceModuleType) throws {
        // Throw if pc factory is already initialized.
        guard !RTC.pcFactoryState.isInitialized else {
            throw LiveKitError(.invalidState, message: "Cannot set this property after the peer connection has been initialized")
        }
        RTC.pcFactoryState.mutate { $0.admType = audioDeviceModuleType }
    }
}
