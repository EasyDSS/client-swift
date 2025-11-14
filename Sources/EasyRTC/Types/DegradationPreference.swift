/* -- */

internal import LiveKitWebRTC

@objc
public enum DegradationPreference: Int, Sendable {
    /// The SDK will decide which preference is suitable or will use WebRTC's default implementation.
    case auto
    case disabled
    /// Prefer to maintain FPS rather than resolution.
    case maintainFramerate
    /// Prefer to maintain resolution rather than FPS.
    case maintainResolution
    case balanced
}

extension DegradationPreference {
    func toRTCType() -> LKRTCDegradationPreference? {
        switch self {
        case .auto: nil
        case .disabled: .disabled
        case .maintainFramerate: .maintainFramerate
        case .maintainResolution: .maintainResolution
        case .balanced: .balanced
        }
    }
}
