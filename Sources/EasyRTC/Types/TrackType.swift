/* -- */

import Foundation

extension Livekit_TrackType {
    func toLKType() -> Track.Kind {
        switch self {
        case .audio:
            .audio
        case .video:
            .video
        default:
            .none
        }
    }
}

extension Track.Kind {
    func toPBType() -> Livekit_TrackType {
        switch self {
        case .audio:
            .audio
        case .video:
            .video
        default:
            .UNRECOGNIZED(10)
        }
    }
}
