/* -- */

import AVFAudio

// A helper class to play-out audio which conforms to the AudioRenderer protocol.
public class AudioPlayerRenderer: AudioRenderer, Loggable, @unchecked Sendable {
    let engine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    var oldConverter: AudioConverter?
    var outputFormat: AVAudioFormat?

    public init() {
        engine.attach(playerNode)
    }

    public func start() async throws {
        log("Starting audio engine...")

        let format = engine.outputNode.outputFormat(forBus: 0)
        outputFormat = format

        engine.connect(playerNode, to: engine.mainMixerNode, format: format)

        try engine.start()
        log("Audio engine started")
    }

    public func stop() {
        log("Stopping audio engine...")

        playerNode.stop()
        engine.stop()

        log("Audio engine stopped")
    }

    public func render(pcmBuffer: AVAudioPCMBuffer) {
        guard let outputFormat, let engine = playerNode.engine, engine.isRunning else { return }

        // Create or update the converter if needed
        let converter = (oldConverter?.inputFormat == pcmBuffer.format)
            ? oldConverter
            : {
                log("Creating converter with format: \(pcmBuffer.format)")
                let newConverter = AudioConverter(from: pcmBuffer.format, to: outputFormat)!
                self.oldConverter = newConverter
                return newConverter
            }()

        guard let converter else { return }

        let buffer = converter.convert(from: pcmBuffer)
        playerNode.scheduleBuffer(buffer, completionHandler: nil)

        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
}
