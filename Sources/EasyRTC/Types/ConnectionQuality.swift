import Foundation

@objc
public enum ConnectionQuality: Int {
    case unknown
    /// Indicates that a participant has temporarily (or permanently) lost connection to LiveKit.
    /// For permanent disconnection, ``RoomDelegate/room(_:participantDidLeave:)`` will be invoked after a timeout.
    case lost
    case poor
    case good
    case excellent
}

extension Livekit_ConnectionQuality {
    func toLKType() -> ConnectionQuality {
        switch self {
        case .poor: return .poor
        case .good: return .good
        case .excellent: return .excellent
        case .lost: return .lost
        default: return .unknown
        }
    }
}
