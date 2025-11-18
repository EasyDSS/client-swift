import Foundation

class AsyncTimer: Loggable {
    // MARK: - Public types

    typealias TimerBlock = () async throws -> Void

    // MARK: - Private

    struct State {
        var isStarted: Bool = false
        var interval: TimeInterval
        var task: Task<Void, Never>?
        var block: TimerBlock?
    }

    let _state: StateSync<State>

    init(interval: TimeInterval) {
        _state = StateSync(State(interval: interval))
    }

    deinit {
        _state.mutate {
            $0.isStarted = false
            $0.task?.cancel()
        }
    }

    func cancel() {
        _state.mutate {
            $0.isStarted = false
            $0.task?.cancel()
        }
    }

    /// Block must not retain self
    func setTimerBlock(block: @escaping TimerBlock) {
        _state.mutate {
            $0.block = block
        }
    }

    /// Update timer interval
    func setTimerInterval(_ timerInterval: TimeInterval) {
        _state.mutate {
            $0.interval = timerInterval
        }
    }

    private func scheduleNextInvocation() async {
        let state = _state.copy()
        guard state.isStarted else { return }
        let task = Task.detached(priority: .utility) { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: UInt64(state.interval * 1_000_000_000))
            if !state.isStarted || Task.isCancelled { return }
            do {
                try await state.block?()
            } catch {
                self.log("Error in timer block: \(error)", .error)
            }
            await self.scheduleNextInvocation()
        }
        _state.mutate { $0.task = task }
    }

    func restart() {
        _state.mutate {
            $0.task?.cancel()
            $0.isStarted = true
        }

        Task { await scheduleNextInvocation() }
    }

    func startIfStopped() {
        if _state.isStarted { return }
        restart()
    }
}
