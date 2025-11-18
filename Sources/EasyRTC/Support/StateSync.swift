import Combine
import Foundation

@dynamicMemberLookup
public final class StateSync<State> {
    // MARK: - Types

    public typealias OnDidMutate = (_ newState: State, _ oldState: State) -> Void

    // MARK: - Public

    public var onDidMutate: OnDidMutate? {
        get { _lock.sync { _onDidMutate } }
        set { _lock.sync { _onDidMutate = newValue } }
    }

    // MARK: - Private

    private var _state: State
    private let _lock = UnfairLock()
    private var _onDidMutate: OnDidMutate?

    public init(_ state: State, onDidMutate: OnDidMutate? = nil) {
        _state = state
        _onDidMutate = onDidMutate
    }

    // mutate sync
    @discardableResult
    public func mutate<Result>(_ block: (inout State) throws -> Result) rethrows -> Result {
        try _lock.sync {
            let oldState = _state
            let result = try block(&_state)
            let newState = _state

            // Always invoke onDidMutate within the lock (sync) since
            // logic following the state mutation may depend on this.
            // Invoke on async queue within _onDidMutate if necessary.
            _onDidMutate?(newState, oldState)

            return result
        }
    }

    // read sync and return copy
    public func copy() -> State {
        _lock.sync { _state }
    }

    // read with block
    public func read<Result>(_ block: (State) throws -> Result) rethrows -> Result {
        try _lock.sync { try block(_state) }
    }

    // property read sync
    public subscript<Property>(dynamicMember keyPath: KeyPath<State, Property>) -> Property {
        _lock.sync { _state[keyPath: keyPath] }
    }
}

extension StateSync: CustomStringConvertible {
    public var description: String {
        "StateSync(\(String(describing: copy()))"
    }
}
