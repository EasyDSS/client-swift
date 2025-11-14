/* -- */

import Foundation

@objc
public enum ConnectionQuality: Int, Sendable {
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
        case .poor: .poor
        case .good: .good
        case .excellent: .excellent
        case .lost: .lost
        default: .unknown
        }
    }
}
