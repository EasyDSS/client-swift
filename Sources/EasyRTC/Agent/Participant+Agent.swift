/* -- */

import Foundation

public extension Participant {
    @objc
    var isAgent: Bool {
        switch kind {
        case .agent: true
        default: false
        }
    }

    var agentState: AgentState {
        _state.agentAttributes?.lkAgentState ?? .idle
    }

    @objc
    var agentStateString: String {
        agentState.rawValue
    }
}

public extension Participant {
    private var publishingOnBehalf: [Participant.Identity: Participant] {
        guard let _room else { return [:] }
        return _room.allParticipants.filter { $0.value._state.agentAttributes?.lkPublishOnBehalf == identity?.stringValue }
    }

    /// The avatar worker participant associated with the agent.
    @objc
    var avatarWorker: Participant? {
        publishingOnBehalf.values.first
    }
}
