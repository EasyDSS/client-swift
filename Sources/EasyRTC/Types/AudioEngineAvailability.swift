/* -- */

internal import LiveKitWebRTC

public struct AudioEngineAvailability: Sendable {
    public static let `default` = AudioEngineAvailability(isInputAvailable: true, isOutputAvailable: true)
    public static let none = AudioEngineAvailability(isInputAvailable: false, isOutputAvailable: false)

    public let isInputAvailable: Bool
    public let isOutputAvailable: Bool

    public init(isInputAvailable: Bool, isOutputAvailable: Bool) {
        self.isInputAvailable = isInputAvailable
        self.isOutputAvailable = isOutputAvailable
    }
}

extension LKRTCAudioEngineAvailability {
    func toLKType() -> AudioEngineAvailability {
        AudioEngineAvailability(isInputAvailable: isInputAvailable.boolValue,
                                isOutputAvailable: isOutputAvailable.boolValue)
    }
}

extension AudioEngineAvailability {
    func toRTCType() -> LKRTCAudioEngineAvailability {
        LKRTCAudioEngineAvailability(isInputAvailable: ObjCBool(isInputAvailable),
                                     isOutputAvailable: ObjCBool(isOutputAvailable))
    }
}
