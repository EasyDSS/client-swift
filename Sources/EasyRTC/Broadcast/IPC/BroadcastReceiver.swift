/* -- */

#if os(iOS)

import AVFoundation
import CoreImage

/// Receives broadcast samples from another process.
final class BroadcastReceiver: Sendable {
    /// Sample received from the other process with associated metadata.
    enum IncomingSample {
        case image(CVImageBuffer, VideoRotation)
        case audio(AVAudioPCMBuffer)
    }

    enum Error: Swift.Error {
        case missingSampleData
    }

    private let channel: IPCChannel

    /// Creates a receiver with an open connection to another process.
    init(socketPath: SocketPath) async throws {
        channel = try await IPCChannel(acceptingOn: socketPath)
    }

    /// Whether or not the connection to the uploader has been closed.
    var isClosed: Bool {
        channel.isClosed
    }

    /// Close the connection to the uploader.
    func close() {
        channel.close()
    }

    struct AsyncSampleSequence: AsyncSequence, AsyncIteratorProtocol, Loggable {
        fileprivate let upstream: IPCChannel.AsyncMessageSequence<BroadcastIPCHeader>

        private let imageCodec = BroadcastImageCodec()
        private let audioCodec = BroadcastAudioCodec()

        func next() async throws -> IncomingSample? {
            while let (header, payload) = try await upstream.next(), let payload {
                switch header {
                case let .image(metadata, rotation):
                    let imageBuffer = try imageCodec.decode(payload, with: metadata)
                    return IncomingSample.image(imageBuffer, rotation)

                case let .audio(metadata):
                    let audioBuffer = try audioCodec.decode(payload, with: metadata)
                    return IncomingSample.audio(audioBuffer)

                default:
                    log("Unhandled incoming message: \(header)", .debug)
                    continue
                }
            }
            return nil
        }

        func makeAsyncIterator() -> Self { self }

        #if swift(<5.11)
        typealias AsyncIterator = Self
        typealias Element = IncomingSample
        #endif
    }

    var incomingSamples: AsyncSampleSequence {
        AsyncSampleSequence(upstream: channel.incomingMessages(BroadcastIPCHeader.self))
    }

    /// Tells the uploader to begin sending audio samples.
    func enableAudio() async throws {
        try await channel.send(header: BroadcastIPCHeader.wantsAudio(true))
    }

    /// Tells the uploader to stop sending audio samples.
    func disableAudio() async throws {
        try await channel.send(header: BroadcastIPCHeader.wantsAudio(false))
    }
}

#endif
