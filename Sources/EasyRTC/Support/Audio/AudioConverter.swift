/* -- */

@preconcurrency import AVFAudio

final class AudioConverter: Sendable {
    let inputFormat: AVAudioFormat
    let outputFormat: AVAudioFormat

    private let converter: AVAudioConverter
    private let outputBuffer: AVAudioPCMBuffer

    /// Computes required frame capacity for output buffer.
    static func frameCapacity(from inputFormat: AVAudioFormat, to outputFormat: AVAudioFormat, inputFrameCount: AVAudioFrameCount) -> AVAudioFrameCount {
        let inputSampleRate = inputFormat.sampleRate
        let outputSampleRate = outputFormat.sampleRate
        // Compute the output frame capacity based on sample rate ratio
        return AVAudioFrameCount(Double(inputFrameCount) * (outputSampleRate / inputSampleRate))
    }

    init?(from inputFormat: AVAudioFormat, to outputFormat: AVAudioFormat, outputBufferCapacity: AVAudioFrameCount = 9600) {
        guard let converter = AVAudioConverter(from: inputFormat, to: outputFormat),
              let buffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: outputBufferCapacity)
        else {
            return nil
        }

        outputBuffer = buffer
        self.converter = converter
        self.inputFormat = inputFormat
        self.outputFormat = outputFormat
    }

    func convert(from inputBuffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer {
        var error: NSError?
        #if swift(>=6.0)
        // Won't be accessed concurrently, marking as nonisolated(unsafe) to avoid Atomics.
        nonisolated(unsafe) var bufferFilled = false
        #else
        var bufferFilled = false
        #endif

        converter.convert(to: outputBuffer, error: &error) { _, outStatus in
            if bufferFilled {
                outStatus.pointee = .noDataNow
                return nil
            }
            outStatus.pointee = .haveData
            bufferFilled = true
            return inputBuffer
        }

        return outputBuffer.copySegment()
    }
}
