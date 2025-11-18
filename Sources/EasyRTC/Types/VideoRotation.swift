#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

public enum VideoRotation: Int, Sendable {
    case _0 = 0
    case _90 = 90
    case _180 = 180
    case _270 = 270
}

extension RTCVideoRotation {
    func toLKType() -> VideoRotation {
        VideoRotation(rawValue: rawValue)!
    }
}

extension VideoRotation {
    func toRTCType() -> RTCVideoRotation {
        RTCVideoRotation(rawValue: rawValue)!
    }
}
