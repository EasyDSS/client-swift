import Foundation

class AsyncSerialDelegate<T> {
    private struct State {
        weak var delegate: AnyObject?
    }

    private let _state = StateSync(State())
    private let _serialRunner = SerialRunnerActor<Void>()

    func set(delegate: T) {
        _state.mutate { $0.delegate = delegate as AnyObject }
    }

    func notifyAsync(_ fnc: @escaping (T) async -> Void) async throws {
        guard let delegate = _state.read({ $0.delegate }) as? T else { return }
        try await _serialRunner.run {
            await fnc(delegate)
        }
    }

    func notifyDetached(_ fnc: @escaping (T) async -> Void) {
        Task.detached {
            try await self.notifyAsync(fnc)
        }
    }
}
