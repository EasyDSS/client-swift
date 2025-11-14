/* -- */

import Foundation

let msecPerSec = 1000

// merge a ClosedRange
func merge<T>(range range1: ClosedRange<T>, with range2: ClosedRange<T>) -> ClosedRange<T> where T: Comparable {
    min(range1.lowerBound, range2.lowerBound) ... max(range1.upperBound, range2.upperBound)
}

// throws a timeout if the operation takes longer than the given timeout
func withThrowingTimeout<T: Sendable>(timeout: TimeInterval,
                                      operation: @Sendable @escaping () async throws -> T) async throws -> T
{
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }

        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            throw LiveKitError(.timedOut)
        }

        let result = try await group.next()

        group.cancelAll()

        guard let result else {
            // This should never happen since we know we added tasks
            throw LiveKitError(.invalidState)
        }

        return result
    }
}
