/* -- */

import Foundation

internal import LiveKitWebRTC

@objc
public enum IceTransportPolicy: Int, Sendable {
    case none
    case relay
    case noHost
    case all
}

extension IceTransportPolicy {
    func toRTCType() -> LKRTCIceTransportPolicy {
        switch self {
        case .none: .none
        case .relay: .relay
        case .noHost: .noHost
        case .all: .all
        }
    }
}
