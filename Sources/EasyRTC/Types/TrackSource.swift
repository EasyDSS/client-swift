/* -- */

import Foundation

extension Livekit_TrackSource {
    func toLKType() -> Track.Source {
        switch self {
        case .camera: .camera
        case .microphone: .microphone
        case .screenShare: .screenShareVideo
        case .screenShareAudio: .screenShareAudio
        default: .unknown
        }
    }
}

extension Track.Source {
    func toPBType() -> Livekit_TrackSource {
        switch self {
        case .camera: .camera
        case .microphone: .microphone
        case .screenShareVideo: .screenShare
        case .screenShareAudio: .screenShareAudio
        default: .unknown
        }
    }
}
