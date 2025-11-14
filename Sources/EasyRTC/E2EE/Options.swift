/* -- */

import Foundation

@objc
public enum EncryptionType: Int, Sendable {
    case none
    case gcm
    case custom
}

extension EncryptionType {
    func toPBType() -> Livekit_Encryption.TypeEnum {
        switch self {
        case .none: .none
        case .gcm: .gcm
        case .custom: .custom
        default: .custom
        }
    }
}

extension Livekit_Encryption.TypeEnum {
    func toLKType() -> EncryptionType {
        switch self {
        case .none: .none
        case .gcm: .gcm
        case .custom: .custom
        default: .custom
        }
    }
}

@available(*, deprecated, message: "Migrate to 'EncryptionOptions' instead. Important: It will enable data channel encryption by default (requires support from all platforms).")
@objc
public final class E2EEOptions: NSObject, Sendable {
    @objc
    public let keyProvider: BaseKeyProvider

    @objc
    public let encryptionType: EncryptionType

    public init(keyProvider: BaseKeyProvider,
                encryptionType: EncryptionType = .gcm)
    {
        self.keyProvider = keyProvider
        self.encryptionType = encryptionType
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return keyProvider == other.keyProvider &&
            encryptionType == other.encryptionType
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(keyProvider)
        hasher.combine(encryptionType)
        return hasher.finalize()
    }
}

@objc
public final class EncryptionOptions: NSObject, Sendable {
    @objc
    public let keyProvider: BaseKeyProvider

    @objc
    public let encryptionType: EncryptionType

    public init(keyProvider: BaseKeyProvider,
                encryptionType: EncryptionType = .gcm)
    {
        self.keyProvider = keyProvider
        self.encryptionType = encryptionType
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return keyProvider == other.keyProvider &&
            encryptionType == other.encryptionType
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(keyProvider)
        hasher.combine(encryptionType)
        return hasher.finalize()
    }
}
