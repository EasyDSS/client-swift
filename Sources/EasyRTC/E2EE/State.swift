import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

@objc
public enum E2EEState: Int, Sendable {
    case new
    case ok
    case key_ratcheted
    case missing_key
    case encryption_failed
    case decryption_failed
    case internal_error
}

public extension E2EEState {
    func toString() -> String {
        switch self {
        case .new: return "new"
        case .ok: return "ok"
        case .key_ratcheted: return "key_ratcheted"
        case .missing_key: return "missing_key"
        case .encryption_failed: return "encryption_failed"
        case .decryption_failed: return "decryption_failed"
        case .internal_error: return "internal_error"
        default: return "internal_error"
        }
    }
}

extension FrameCryptionState {
    func toLKType() -> E2EEState {
        switch self {
        case .new: return .new
        case .ok: return .ok
        case .keyRatcheted: return .key_ratcheted
        case .missingKey: return .missing_key
        case .encryptionFailed: return .encryption_failed
        case .decryptionFailed: return .decryption_failed
        case .internalError: return .internal_error
        default: return .internal_error
        }
    }
}
