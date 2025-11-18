import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public enum IceTransportPolicy: Int, Sendable {
    case none
    case relay
    case noHost
    case all
}

extension IceTransportPolicy {
    func toRTCType() -> RTCIceTransportPolicy {
        switch self {
        case .none: return .none
        case .relay: return .relay
        case .noHost: return .noHost
        case .all: return .all
        }
    }
}
