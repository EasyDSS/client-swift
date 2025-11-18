let agentStateAttributeKey = "lk.agent.state"

@objc
public enum AgentState: Int {
    case unknown
    case disconnected
    case connecting
    case initializing
    case listening
    case thinking
    case speaking
}

extension AgentState {
    static func fromString(_ rawString: String?) -> AgentState? {
        switch rawString {
        case "initializing": return .initializing
        case "listening": return .listening
        case "thinking": return .thinking
        case "speaking": return .speaking
        default: return unknown
        }
    }
}

extension AgentState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .initializing: return "Initializing"
        case .listening: return "Listening"
        case .thinking: return "Thinking"
        case .speaking: return "Speaking"
        }
    }
}
