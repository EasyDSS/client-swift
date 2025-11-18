import Foundation

@objc
public enum ProtocolVersion: Int, Sendable {
    case v8 = 8
    case v9 = 9
    case v10 = 10 /// Sync stream id
    case v11 = 11 /// Supports ``ConnectionQuality/lost``
    case v12 = 12 /// Faster room join (delayed ``Room/sid``)
}

// MARK: - Comparable

extension ProtocolVersion: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - CustomStringConvertible

extension ProtocolVersion: CustomStringConvertible {
    public var description: String {
        String(rawValue)
    }
}
