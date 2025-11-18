import Foundation

@objc
public enum VideoQuality: Int, Sendable {
    case low
    case medium
    case high
}

extension VideoQuality {
    static let RIDs = ["q", "h", "f"]
}

// Make convertible between protobuf type.
extension VideoQuality {
    private static let toPBTypeMap: [VideoQuality: Livekit_VideoQuality] = [
        .low: .low,
        .medium: .medium,
        .high: .high,
    ]

    func toPBType() -> Livekit_VideoQuality {
        Self.toPBTypeMap[self] ?? .low
    }
}

// Make convertible between RIDs.
extension Livekit_VideoQuality {
    static func from(rid: String?) -> Livekit_VideoQuality? {
        switch rid {
        case "q": return Livekit_VideoQuality.low
        case "h": return Livekit_VideoQuality.medium
        case "f": return Livekit_VideoQuality.high
        default: return nil
        }
    }

    var asRID: String? {
        switch self {
        case .low: return "q"
        case .medium: return "h"
        case .high: return "f"
        default: return nil
        }
    }
}

// Make comparable by the real quality index since the raw protobuf values are not in order.
// E.g. value of `.off` is `3` which is larger than `.high`.
extension Livekit_VideoQuality: Comparable {
    private var _weightIndex: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        default: return 0
        }
    }

    static func < (lhs: Livekit_VideoQuality, rhs: Livekit_VideoQuality) -> Bool {
        lhs._weightIndex < rhs._weightIndex
    }
}
