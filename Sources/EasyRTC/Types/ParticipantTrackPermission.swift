import Foundation

@objc
public final class ParticipantTrackPermission: NSObject, Sendable {
    /**
     * The participant id this permission applies to.
     */
    @objc
    public let participantSid: String

    /**
     * If set to true, the target participant can subscribe to all tracks from the local participant.
     *
     * Takes precedence over ``allowedTrackSids``.
     */
    @objc
    let allTracksAllowed: Bool

    /**
     * The list of track ids that the target participant can subscribe to.
     */
    @objc
    let allowedTrackSids: [String]

    @objc
    public init(participantSid: String,
                allTracksAllowed: Bool,
                allowedTrackSids: [String] = [String]())
    {
        self.participantSid = participantSid
        self.allTracksAllowed = allTracksAllowed
        self.allowedTrackSids = allowedTrackSids
    }
}

extension ParticipantTrackPermission {
    func toPBType() -> Livekit_TrackPermission {
        Livekit_TrackPermission.with {
            $0.participantSid = self.participantSid
            $0.allTracks = self.allTracksAllowed
            $0.trackSids = self.allowedTrackSids
        }
    }
}
