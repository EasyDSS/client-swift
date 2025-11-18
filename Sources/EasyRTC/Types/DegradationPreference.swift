#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

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
    func toRTCType() -> RTCDegradationPreference? {
        switch self {
        case .auto: return nil
        case .disabled: return .disabled
        case .maintainFramerate: return .maintainFramerate
        case .maintainResolution: return .maintainResolution
        case .balanced: return .balanced
        }
    }
}
