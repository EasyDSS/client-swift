import Foundation

public extension Room {
    /// Returns a dictionary containing both local and remote participants.
    var allParticipants: [Participant.Identity: Participant] {
        var result: [Participant.Identity: Participant] = remoteParticipants
        if let localParticipantIdentity = localParticipant.identity {
            result.updateValue(localParticipant, forKey: localParticipantIdentity)
        }
        return result
    }
}
