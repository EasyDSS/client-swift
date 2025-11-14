/* -- */

@preconcurrency import AVFoundation
import CoreMedia

internal import LiveKitWebRTC

/// Used to observe audio buffers before playback, e.g. for visualization, recording, etc
/// - Note: AudioRenderer is not suitable for buffer modification. If you need to modify the buffer, use `AudioCustomProcessingDelegate` instead.
@objc
public protocol AudioRenderer: Sendable {
    @objc
    func render(pcmBuffer: AVAudioPCMBuffer)
}

class AudioRendererAdapter: MulticastDelegate<AudioRenderer>, @unchecked Sendable, LKRTCAudioRenderer {
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
