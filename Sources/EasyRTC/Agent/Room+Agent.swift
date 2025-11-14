/* -- */

import Foundation

public extension Room {
    /// A dictionary containing all agent participants.
    ///
    /// - Note: This will not include participants that are publishing on behalf of another participant
    /// e.g. avatar workers. To access them directly use ``Participant/avatarWorker`` property of `agentParticipant`.
    @objc
    var agentParticipants: [Participant.Identity: Participant] {
        allParticipants.filter { $0.value.isAgent && $0.value._state.agentAttributes?.lkPublishOnBehalf == nil }
    }

    /// The first agent participant.
    @objc
    var agentParticipant: Participant? {
        agentParticipants.values.first
    }
}
