/* -- */

import Foundation

internal import LiveKitWebRTC

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
        case .new: "new"
        case .ok: "ok"
        case .key_ratcheted: "key_ratcheted"
        case .missing_key: "missing_key"
        case .encryption_failed: "encryption_failed"
        case .decryption_failed: "decryption_failed"
        case .internal_error: "internal_error"
        default: "internal_error"
        }
    }
}

extension LKRTCFrameCryptorState {
    func toLKType() -> E2EEState {
        switch self {
        case .new: .new
        case .ok: .ok
        case .keyRatcheted: .key_ratcheted
        case .missingKey: .missing_key
        case .encryptionFailed: .encryption_failed
        case .decryptionFailed: .decryption_failed
        case .internalError: .internal_error
        default: .internal_error
        }
    }
}
