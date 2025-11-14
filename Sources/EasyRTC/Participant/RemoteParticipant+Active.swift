/* -- */

import Foundation

public extension RemoteParticipant {
    /// Waits until the participant is active.
    ///
    /// - Parameters:
    ///   - timeout: The timeout for the operation.
    /// - Throws: `LiveKitError` if the participant is not active within the timeout.
    @discardableResult
    func waitUntilActive(timeout: TimeInterval = .defaultParticipantActiveTimeout) async throws -> Self {
        let room = try requireRoom()
        let identity = try requireIdentity()
        try await room.activeParticipantCompleters.completer(for: identity.stringValue).wait(timeout: timeout)
        return self
    }
}

public extension Collection<RemoteParticipant> {
    /// Waits until all participants are active.
    ///
    /// - Parameters:
    ///   - timeout: The timeout for the operation.
    /// - Throws: `LiveKitError` if the participants are not active within the timeout.
    @discardableResult
    func waitUntilAllActive(timeout: TimeInterval = .defaultParticipantActiveTimeout) async throws -> Self {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for participant in self {
                group.addTask {
                    try await participant.waitUntilActive(timeout: timeout)
                }
            }
            try await group.waitForAll()
        }
        return self
    }

    /// Waits until any participant is active.
    ///
    /// - Parameters:
    ///   - timeout: The timeout for the operation.
    /// - Throws: `LiveKitError` if no participant is active within the timeout.
    @discardableResult
    func waitUntilAnyActive(timeout: TimeInterval = .defaultParticipantActiveTimeout) async throws -> Self {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for participant in self {
                group.addTask {
                    try await participant.waitUntilActive(timeout: timeout)
                }
            }
            for try await _ in group.prefix(1) {
                group.cancelAll()
            }
        }
        return self
    }
}
