import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public enum StreamState: Int, Sendable {
    case paused
    case active
}

extension Livekit_StreamState {
    func toLKType() -> StreamState {
        switch self {
        case .active: return .active
        default: return .paused
        }
    }
}
