/* -- */

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
        case "q": Livekit_VideoQuality.low
        case "h": Livekit_VideoQuality.medium
        case "f": Livekit_VideoQuality.high
        default: nil
        }
    }

    var asRID: String? {
        switch self {
        case .low: "q"
        case .medium: "h"
        case .high: "f"
        default: nil
        }
    }
}

// Make comparable by the real quality index since the raw protobuf values are not in order.
// E.g. value of `.off` is `3` which is larger than `.high`.
extension Livekit_VideoQuality: Comparable {
    private var _weightIndex: Int {
        switch self {
        case .low: 1
        case .medium: 2
        case .high: 3
        default: 0
        }
    }

    static func < (lhs: Livekit_VideoQuality, rhs: Livekit_VideoQuality) -> Bool {
        lhs._weightIndex < rhs._weightIndex
    }
}
