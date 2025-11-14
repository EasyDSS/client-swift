/* -- */

import Foundation

internal import LiveKitWebRTC

@objc
public enum StreamState: Int, Sendable {
    case paused
    case active
}

extension Livekit_StreamState {
    func toLKType() -> StreamState {
        switch self {
        case .active: .active
        default: .paused
        }
    }
}
