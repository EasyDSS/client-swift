import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

public let kLiveKitKrispAudioProcessorName = "livekit_krisp_noise_cancellation"

@objc
public protocol AudioCustomProcessingDelegate {
    @objc optional var audioProcessingName: String { get }

    @objc
    func audioProcessingInitialize(sampleRate sampleRateHz: Int, channels: Int)

    @objc
    func audioProcessingProcess(audioBuffer: LKAudioBuffer)

    @objc
    func audioProcessingRelease()
}

class AudioCustomProcessingDelegateAdapter: MulticastDelegate<AudioRenderer>, LKRTCAudioCustomProcessingDelegate {
    // MARK: - Public

    var target: AudioCustomProcessingDelegate? { _state.target }

    // MARK: - Private

    private struct State {
        weak var target: AudioCustomProcessingDelegate?
    }

    private var _state = StateSync(State())

    func set(target: AudioCustomProcessingDelegate?) {
        _state.mutate { $0.target = target }
    }

    init() {
        super.init(label: "AudioCustomProcessingDelegateAdapter")
    }

    // MARK: - AudioCustomProcessingDelegate

    func audioProcessingInitialize(sampleRate sampleRateHz: Int, channels: Int) {
        target?.audioProcessingInitialize(sampleRate: sampleRateHz, channels: channels)
    }

    func audioProcessingProcess(audioBuffer: LKRTCAudioBuffer) {
        let lkAudioBuffer = LKAudioBuffer(audioBuffer: audioBuffer)
        target?.audioProcessingProcess(audioBuffer: lkAudioBuffer)

        // Convert to pcmBuffer and notify only if an audioRenderer is added.
        if isDelegatesNotEmpty, let pcmBuffer = lkAudioBuffer.toAVAudioPCMBuffer() {
            notify { $0.render(pcmBuffer: pcmBuffer) }
        }
    }

    func audioProcessingRelease() {
        target?.audioProcessingRelease()
    }
}
