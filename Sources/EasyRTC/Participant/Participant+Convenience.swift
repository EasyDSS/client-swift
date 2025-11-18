import Foundation

public extension Participant {
    var firstCameraPublication: TrackPublication? {
        videoTracks.first(where: { $0.source == .camera })
    }

    var firstScreenSharePublication: TrackPublication? {
        videoTracks.first(where: { $0.source == .screenShareVideo })
    }

    var firstAudioPublication: TrackPublication? {
        audioTracks.first
    }

    var firstTrackEncryptionType: EncryptionType {
        if let pub = firstCameraPublication {
            return pub.encryptionType
        } else if let pub = firstScreenSharePublication {
            return pub.encryptionType
        } else if let pub = firstAudioPublication {
            return pub.encryptionType
        } else {
            return .none
        }
    }

    var firstCameraVideoTrack: VideoTrack? {
        guard let pub = firstCameraPublication, !pub.isMuted, pub.isSubscribed,
              let track = pub.track else { return nil }
        return track as? VideoTrack
    }

    var firstScreenShareVideoTrack: VideoTrack? {
        guard let pub = firstScreenSharePublication, !pub.isMuted, pub.isSubscribed,
              let track = pub.track else { return nil }
        return track as? VideoTrack
    }

    var firstAudioTrack: AudioTrack? {
        guard let pub = firstAudioPublication, !pub.isMuted,
              let track = pub.track else { return nil }
        return track as? AudioTrack
    }
}
