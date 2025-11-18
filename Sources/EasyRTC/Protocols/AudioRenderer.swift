import AVFoundation
import CoreMedia

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public protocol AudioRenderer {
    @objc
    func render(pcmBuffer: AVAudioPCMBuffer)
}

class AudioRendererAdapter: MulticastDelegate<AudioRenderer>, LKRTCAudioRenderer {
    //
    typealias Delegate = AudioRenderer

    init() {
        super.init(label: "AudioRendererAdapter")
    }

    // MARK: - LKRTCAudioRenderer

    func render(pcmBuffer: AVAudioPCMBuffer) {
        notify { $0.render(pcmBuffer: pcmBuffer) }
    }
}
