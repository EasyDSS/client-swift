/* -- */

internal import LiveKitWebRTC

// MARK: - Public

public enum MicrophoneMuteMode {
    /// Uses `AVAudioEngine`'s `isVoiceProcessingInputMuted` internally.
    /// This is fast, and muted speaker detection works. However, iOS will play a sound effect.
    case voiceProcessing
    /// Restarts the internal `AVAudioEngine` without mic input when muted.
    /// This is slower, and muted speaker detection does not work. No sound effect is played.
    case restart
    /// Simply mutes the output of the input mixer.
    /// The mic indicator remains on, and the internal `AVAudioEngine` continues running without reconfiguration.
    case inputMixer
    case unknown
}

public extension AudioManager {
    var microphoneMuteMode: MicrophoneMuteMode {
        RTC.audioDeviceModule.muteMode.toLKType()
    }

    func set(microphoneMuteMode mode: MicrophoneMuteMode) throws {
        guard mode != .unknown else {
            throw LiveKitError(.invalidState, message: "Unsupported mute mode specified")
        }
        let result = RTC.audioDeviceModule.setMuteMode(mode.toRTCType())
        try checkAdmResult(code: result)
    }
}

// MARK: - Public Deprecated

public extension AudioManager {
    /// Set to `true` to enable legacy mic mute mode.
    ///
    /// - Default: Uses `AVAudioEngine`'s `isVoiceProcessingInputMuted` internally.
    ///   This is fast, and muted speaker detection works. However, iOS will play a sound effect.
    /// - Legacy: Restarts the internal `AVAudioEngine` without mic input when muted.
    ///   This is slower, and muted speaker detection does not work. No sound effect is played.
    @available(*, deprecated, message: "Use `muteMode` instead")
    var isLegacyMuteMode: Bool { RTC.audioDeviceModule.muteMode == .restartEngine }

    @available(*, deprecated, message: "Use `set(muteMode:)` instead")
    func setLegacyMuteMode(_ enabled: Bool) throws {
        let mode: LKRTCAudioEngineMuteMode = enabled ? .restartEngine : .voiceProcessing
        let result = RTC.audioDeviceModule.setMuteMode(mode)
        try checkAdmResult(code: result)
    }
}

// MARK: - Internal

extension LKRTCAudioEngineMuteMode {
    func toLKType() -> MicrophoneMuteMode {
        switch self {
        case .voiceProcessing: return .voiceProcessing
        case .restartEngine: return .restart
        case .inputMixer: return .inputMixer
        case .unknown: return .unknown
        @unknown default: return .unknown
        }
    }
}

extension MicrophoneMuteMode {
    func toRTCType() -> LKRTCAudioEngineMuteMode {
        switch self {
        case .unknown: .unknown
        case .voiceProcessing: .voiceProcessing
        case .restart: .restartEngine
        case .inputMixer: .inputMixer
        }
    }
}
