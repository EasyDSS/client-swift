/* -- */

// MARK: - Public

public extension Participant {
    @objc
    enum Kind: Int, Sendable {
        case unknown
        /// Standard participants, e.g. web clients.
        case standard
        /// Only ingests streams.
        case ingress
        /// Only consumes streams.
        case egress
        /// SIP participants.
        case sip
        /// LiveKit agents.
        case agent
    }
}

extension Participant.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: "unknown"
        case .standard: "standard"
        case .ingress: "ingress"
        case .egress: "egress"
        case .sip: "sip"
        case .agent: "agent"
        }
    }
}

// MARK: - Internal

extension Livekit_ParticipantInfo.Kind {
    func toLKType() -> Participant.Kind {
        switch self {
        case .standard: .standard
        case .ingress: .ingress
        case .egress: .egress
        case .sip: .sip
        case .agent: .agent
        default: .unknown
        }
    }
}
