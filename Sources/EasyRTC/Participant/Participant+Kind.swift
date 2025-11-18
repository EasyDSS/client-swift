// MARK: - Public

public extension Participant {
    @objc
    enum Kind: Int {
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
        case .unknown: return "unknown"
        case .standard: return "standard"
        case .ingress: return "ingress"
        case .egress: return "egress"
        case .sip: return "sip"
        case .agent: return "agent"
        }
    }
}

// MARK: - Internal

extension Livekit_ParticipantInfo.Kind {
    func toLKType() -> Participant.Kind {
        switch self {
        case .standard: return .standard
        case .ingress: return .ingress
        case .egress: return .egress
        case .sip: return .sip
        case .agent: return .agent
        default: return .unknown
        }
    }
}
