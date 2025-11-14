/* -- */

import Foundation

/// Asynchronously write to an open text stream.
@objc
public final class TextStreamWriter: NSObject, Sendable {
    /// Information about the outgoing text stream.
    @objc
    public let info: TextStreamInfo

    private let destination: StreamWriterDestination

    /// Whether or not the stream is still open.
    public var isOpen: Bool {
        get async { await destination.isOpen }
    }

    /// Write text to the stream.
    ///
    /// - Parameter text: Text to be sent.
    /// - Throws: Throws an error if the stream has been closed or text
    ///   cannot be sent to remote participants.
    ///
    public func write(_ text: String) async throws {
        try await destination.write(text)
    }

    /// Close the stream.
    ///
    /// - Parameter reason: A textual description of why the stream is being closed. Absense
    ///   of a reason indicates a normal closure.
    /// - Throws: Throws an error if the stream has already been closed or closure
    ///   cannot be communicated to remote participants.
    ///
    public func close(reason: String? = nil) async throws {
        try await destination.close(reason: reason)
    }

    init(info: TextStreamInfo, destination: StreamWriterDestination) {
        self.info = info
        self.destination = destination
    }
}

// MARK: - Objective-C compatibility

public extension TextStreamWriter {
    @objc
    @available(*, unavailable, message: "Use async write(_:) method instead.")
    func write(_ text: String, onCompletion: @Sendable @escaping (Error?) -> Void) {
        Task {
            do { try await write(text) }
            catch { onCompletion(error) }
        }
    }

    @objc
    @available(*, unavailable, message: "Use async close(reason:) method instead.")
    func close(reason: String?, onCompletion: @Sendable @escaping (Error?) -> Void) {
        Task {
            do { try await close(reason: reason) }
            catch { onCompletion(error) }
        }
    }
}
