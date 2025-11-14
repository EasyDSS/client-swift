/* -- */

/// Allows distinguishing between setting nil and no-op in copyWith operations.
public enum ValueOrAbsent<T: Sendable>: Sendable {
    case value(T)
    case absent

    func value(ifAbsent other: T) -> T {
        switch self {
        case let .value(t): t
        case .absent: other
        }
    }
}
