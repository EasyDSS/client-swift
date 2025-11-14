/* -- */

internal import LiveKitWebRTC

public enum VideoRotation: Int, Sendable, Codable {
    case _0 = 0
    case _90 = 90
    case _180 = 180
    case _270 = 270
}

extension LKRTCVideoRotation {
    func toLKType() -> VideoRotation {
        VideoRotation(rawValue: rawValue)!
    }
}

extension VideoRotation {
    func toRTCType() -> LKRTCVideoRotation {
        LKRTCVideoRotation(rawValue: rawValue)!
    }
}
