/* -- */

internal import LiveKitWebRTC

public enum SpeechActivityEvent {
    case started
    case ended
}

extension LKRTCSpeechActivityEvent {
    func toLKType() -> SpeechActivityEvent {
        switch self {
        case .started: return .started
        case .ended: return .ended
        @unknown default: return .ended
        }
    }
}
