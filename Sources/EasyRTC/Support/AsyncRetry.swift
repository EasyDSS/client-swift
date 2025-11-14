/* -- */

import Foundation

extension Task where Failure == Error {
    static func retrying(
        priority: TaskPriority? = nil,
        totalAttempts: Int = 3,
        retryDelay: TimeInterval = 1,
        @_implicitSelfCapture operation: @Sendable @escaping (_ currentAttempt: Int, _ totalAttempts: Int) async throws -> Success
    ) -> Task {
        retrying(priority: priority, totalAttempts: totalAttempts,
                 retryDelay: { @Sendable _ in retryDelay },
                 operation: operation)
    }

    static func retrying(
        priority: TaskPriority? = nil,
        totalAttempts: Int,
        retryDelay: @Sendable @escaping (_ attempt: Int) -> TimeInterval,
        @_implicitSelfCapture operation: @Sendable @escaping (_ currentAttempt: Int, _ totalAttempts: Int) async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for currentAttempt in 1 ..< max(1, totalAttempts) {
                let delay = retryDelay(currentAttempt - 1)
                print("[Retry] Attempt \(currentAttempt) of \(totalAttempts), delay: \(delay)")
                do {
                    return try await operation(currentAttempt, totalAttempts)
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delayNS = UInt64(oneSecond * delay)
                    print("[Retry] Waiting for \(delay) seconds...")
                    try await Task<Never, Never>.sleep(nanoseconds: delayNS)
                    continue
                }
            }

            try Task<Never, Never>.checkCancellation()
            return try await operation(totalAttempts, totalAttempts)
        }
    }
}
