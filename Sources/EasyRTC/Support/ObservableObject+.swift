/* -- */

@preconcurrency import Combine

extension ObservableObject {
    /// An async stream that emits the `objectWillChange` events.
    var changes: AsyncStream<Void> {
        AsyncStream { continuation in
            let cancellable = objectWillChange.sink { _ in
                continuation.yield()
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}
