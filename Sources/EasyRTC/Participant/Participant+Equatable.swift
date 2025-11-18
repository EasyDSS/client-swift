import Foundation

// Objects are considered equal if both states are equal

public extension Participant {
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(_state.copy())
        return hasher.finalize()
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return _state.copy() == other._state.copy()
    }
}
